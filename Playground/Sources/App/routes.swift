import Vapor
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import PowerAssertPlugin

private let testModuleName = "TestModule"
private let testFileName = "test.swift"

private let healthcheckResponse = ["status": "pass"]

private let notificationName = Notification.Name("onOutput")
enum LogType: String {
  case build
  case test
}

func routes(_ app: Application) throws {
  app.get("health") { _ in healthcheckResponse }
  app.get("healthz") { _ in healthcheckResponse }

  app.get { (req) in
    return req.view.render("index")
  }

  app.on(.POST, "run", body: .collect(maxSize: "10mb")) { (req) -> MacroExpansionResponse in
    guard let request = try? req.content.decode(MacroExpansionRequest.self) else {
      throw Abort(.badRequest)
    }

    let session = request.session
    let sourceFile = Parser.parse(source: request.code)

    let commonOptions = [
      "--disable-dependency-cache", "--disable-build-manifest-caching", "--manifest-cache=none", "--skip-update"
    ]
    do {
      let eraser = MacroEraser()
      let code = "\(eraser.rewrite(Syntax(sourceFile)))"

      let outputNotifier = BufferedNotifier()
      let errorNotifier = BufferedNotifier()

      let status = try await runInTemporaryDirectory(code: code) {
        let command = Command(
          ["/usr/bin/env", "swift", "build", "--build-tests"] + commonOptions,
          workingDirectory: $0
        )
        return try await command.run(
          onOutput: { (output) in
            outputNotifier.send(output, session: session, type: .build)
          },
          onError: { (output) in
            errorNotifier.send(output, session: session, type: .build)
          }
        )
      }

      notify(session: session, type: .build, message: outputNotifier.storage)
      notify(session: session, type: .build, message: errorNotifier.storage)

      guard status.isSuccess else {
        return MacroExpansionResponse(
          stdout: "",
          stderr: "\(status.stdout)\(status.stderr)"
        )
      }
    } catch {
      throw Abort(.internalServerError)
    }

    do {
      let macros: [String: Macro.Type] = [
        "assert": PowerAssertMacro.self,
      ]
      let context = BasicMacroExpansionContext(
        sourceFiles: [sourceFile: .init(moduleName: testModuleName, fullFilePath: testFileName)]
      )
      let code = "\(sourceFile.expand(macros: macros, in: context))"

      let outputNotifier = BufferedNotifier()
      let errorNotifier = BufferedNotifier()

      let status = try await runInTemporaryDirectory(code: code) {
        let command = Command(
          ["/usr/bin/env", "swift", "test"] + commonOptions,
          workingDirectory: $0
        )
        return try await command.run(
          onOutput: { (output) in
            outputNotifier.send(output, session: session, type: .test)
          },
          onError: { (output) in
            errorNotifier.send(output, session: session, type: .build)
          }
        )
      }

      notify(session: session, type: .test, message: outputNotifier.storage)
      notify(session: session, type: .build, message: errorNotifier.storage)

      if !status.stdout.isEmpty && !status.stderr.isEmpty {
        return MacroExpansionResponse(stdout: status.stdout, stderr: "")
      } else {
        return MacroExpansionResponse(stdout: status.stdout, stderr: status.stderr)
      }
    } catch {
      throw Abort(.internalServerError)
    }
  }

  app.webSocket("logs", ":session") { (req, ws) in
    guard let session = req.parameters.get("session") else {
      _ = ws.close()
      return
    }
    let cancelToken = NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { (notification) in
      guard let userInfo = notification.userInfo else {
        return
      }
      guard userInfo["session"] as? String == session else {
        return
      }
      guard let type = userInfo["type"] as? String else {
        return
      }
      guard let message = userInfo["message"] as? String else {
        return
      }
      let response = StreamResponse(type: type, message: message)
      if let data = try? JSONEncoder().encode(response) {
        ws.send(String(decoding: data, as: UTF8.self))
      }
    }
    _ = ws.onClose.always { _ in
      NotificationCenter.default.removeObserver(cancelToken)
    }
  }
}

private func runInTemporaryDirectory(code: String, execute: (URL) async throws -> CommandStatus) async throws -> CommandStatus {
  let fileManager = FileManager()
  let templateDirectory = URL(
    fileURLWithPath: "\(DirectoryConfiguration.detect().resourcesDirectory)\(testModuleName)"
  )

  let temporaryDirectory = fileManager.temporaryDirectory.appendingPathComponent(UUID().base64())
  try fileManager.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true, attributes: nil)
  defer {
    try? fileManager.removeItem(at: temporaryDirectory)
  }

  let packageDirectory = temporaryDirectory.appendingPathComponent(templateDirectory.lastPathComponent)
  try copyItem(at: templateDirectory, to: packageDirectory)

  let testFile = packageDirectory.appendingPathComponent("Tests/TestTarget/test.swift")
  try code.write(to: testFile, atomically: true, encoding: .utf8)

  return try await execute(packageDirectory)
}

private func copyItem(at srcURL: URL, to dstURL: URL) throws {
#if os(Linux)
  try FileManager().copyItem(at: srcURL, to: dstURL)
#else
  let process = Process()
  process.executableURL = URL(fileURLWithPath: "/bin/cp")
  process.arguments = ["-R", "-L", srcURL.path, dstURL.path]

  try process.run()
  process.waitUntilExit()
#endif
}

private func notify(session: String, type: LogType, message: String) {
  NotificationCenter.default.post(
    name: notificationName,
    object: nil,
    userInfo: ["session": session, "type": "\(type)", "message": message]
  )
}

private extension UUID {
  func base64() -> String {
    let uuidBytes = withUnsafeBytes(of: uuid) { Data(bytes: $0.baseAddress!, count: $0.count) }
    let base64String = uuidBytes.base64EncodedString()
    let urlSafeString = base64String
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "+", with: "-")
      .trimmingCharacters(in: CharacterSet(charactersIn: "="))
    return urlSafeString
  }
}

private struct MacroExpansionRequest: Codable {
  let session: String
  let code: String
}

private struct MacroExpansionResponse: Content {
  let stdout: String
  let stderr: String
}

private struct StreamResponse: Codable {
  let type: String
  let message: String
}

private class BufferedNotifier {
  var storage = ""

  func send(_ output: String, session: String, type: LogType) {
    var message = storage
    for character in output {
      if character == "\n" {
        notify(session: session, type: type, message: message)
        message = ""
      } else {
        message.append(character)
      }
    }
    storage = message
  }
}
