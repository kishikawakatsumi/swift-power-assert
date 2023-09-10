import Vapor

private let healthcheckResponse = ["status": "pass"]
private let notificationName = Notification.Name("onOutput")

func routes(_ app: Application) throws {
  app.get("health") { _ in healthcheckResponse }
  app.get("healthz") { _ in healthcheckResponse }

  app.get { (req) in
    return req.view.render("index")
  }

  app.on(.POST, "run", body: .collect(maxSize: "10mb")) { (req) -> PlaygroundResponse in
    guard let request = try? req.content.decode(PlaygroundRequest.self) else {
      throw Abort(.badRequest)
    }

    do {
      let outputNotifier = BufferedNotifier()
      let errorNotifier = BufferedNotifier()

      let session = request.session
      let commonOptions = [
        "--disable-dependency-cache", "--disable-build-manifest-caching", "--manifest-cache=none", "--skip-update"
      ]

      let status = try await runInTemporaryDirectory(code: request.code) {
        let command = Command(
          ["/usr/bin/env", "swift", "test"] + commonOptions,
          workingDirectory: $0
        )
        return try await command.run(
          onOutput: { outputNotifier.send($0, session: session) },
          onError: { errorNotifier.send($0, session: session) }
        )
      }

      notify(session: session, message: outputNotifier.storage)
      notify(session: session, message: errorNotifier.storage)

      if status.stdout.isEmpty {
        let parameters: [String: Any] = [
          "title": "Build error from power-assert.swiftfiddle.com",
          "body": """
          ```swift
          \(request.code)
          ```
          """,
        ]
        if let token = Environment.get("GH_PAT"),
           let data = try? JSONSerialization.data(withJSONObject: parameters) {
          _ = try? await req.client.send(
            ClientRequest(
              method: .POST,
              url: "https://api.github.com/repos/kishikawakatsumi/swift-power-assert/issues",
              headers: [
                "Accept": "application/vnd.github.v3+json",
                "Authorization": "token \(token)",
                "User-Agent": "power-assert.swiftfiddle.com",
              ],
              body: ByteBuffer(data: data)
            )
          )
        }
      }

      if !status.stdout.isEmpty && !status.stderr.isEmpty {
        return PlaygroundResponse(stdout: status.stdout, stderr: "")
      } else {
        return PlaygroundResponse(stdout: status.stdout, stderr: status.stderr)
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
      guard let message = userInfo["message"] as? String else {
        return
      }
      let response = StreamResponse(message: message)
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

  let resourcesDirectory = DirectoryConfiguration.detect().resourcesDirectory
  let templateDirectory = URL(fileURLWithPath: "\(resourcesDirectory)TestModule")

  let temporaryDirectory = URL(fileURLWithPath: resourcesDirectory).appendingPathComponent(UUID().base64())
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

private func notify(session: String, message: String) {
  NotificationCenter.default.post(
    name: notificationName,
    object: nil,
    userInfo: ["session": session, "message": message]
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

private struct PlaygroundRequest: Codable {
  let session: String
  let code: String
}

private struct PlaygroundResponse: Content {
  let stdout: String
  let stderr: String
}

private struct StreamResponse: Codable {
  let message: String
}

private class BufferedNotifier {
  var storage = ""

  func send(_ output: String, session: String) {
    var message = storage
    for character in output {
      if character == "\r" {
        notify(session: session, message: message.replacingOccurrences(of: "[2K", with: ""))
        message = ""
      } else {
        if character == "\u{001B}" {
          continue
        }
        message.append(character)
      }
    }
    storage = message
  }
}
