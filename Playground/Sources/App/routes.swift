import Vapor
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import PowerAssertPlugin

private let testModuleName = "TestModule"
private let testFileName = "test.swift"

func routes(_ app: Application) throws {
  app.get("health") { _ in ["status": "pass"] }
  app.get("healthz") { _ in ["status": "pass"] }

  app.get { (req) in
    return req.view.render("index")
  }

  app.on(.POST, "run", body: .collect(maxSize: "10mb")) { (req) -> MacroExpansionResponse in
    guard let request = try? req.content.decode(MacroExpansionRequest.self) else {
      throw Abort(.badRequest)
    }

    let macros: [String: Macro.Type] = [
      "assert": PowerAssertMacro.self,
    ]

    let sourceFile = Parser.parse(source: request.code)

    let eraser = MacroEraser()
    do {
      let (status, stdout, stderr) = try await runBuild(code: "\(eraser.rewrite(Syntax(sourceFile)))")
      guard status == 0 else {
        return MacroExpansionResponse(
          stdout: "",
          stderr: stdout + stderr
        )
      }
    } catch {
      throw Abort(.internalServerError)
    }

    do {
      let context = BasicMacroExpansionContext(
        sourceFiles: [sourceFile: .init(moduleName: testModuleName, fullFilePath: testFileName)]
      )
      let (_, stdout, stderr) = try await runTest(code: "\(sourceFile.expand(macros: macros, in: context))")
      let response = MacroExpansionResponse(
        stdout: stdout,
        stderr: stderr
      )
      return response
    } catch {
      throw Abort(.internalServerError)
    }
  }
}

private func runBuild(code: String) async throws -> (Int32, String, String) {
  try await runInTemporaryDirectory(code: code) { (temporaryDirectory) in
    try await runProcess(
      "/usr/bin/swift", arguments: ["build", "--build-tests"], workingDirectory: temporaryDirectory
    )
  }
}

private func runTest(code: String) async throws -> (Int32, String, String) {
  try await runInTemporaryDirectory(code: code) { (temporaryDirectory) in
    try await runProcess(
      "/usr/bin/swift", arguments: ["test"], workingDirectory: temporaryDirectory
    )
  }
}

func runInTemporaryDirectory(code: String, execute: (URL) async throws -> (Int32, String, String)) async throws -> (Int32, String, String) {
  let templateDirectory = URL(
    fileURLWithPath: "\(DirectoryConfiguration.detect().resourcesDirectory)\(testModuleName)"
  )

  let fileManager = FileManager()
  let temporaryDirectory = fileManager.temporaryDirectory.appendingPathComponent(UUID().base64())
  try fileManager.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true, attributes: nil)

  let packageDirectory = temporaryDirectory.appendingPathComponent(templateDirectory.lastPathComponent)
  try fileManager.copyItem(at: templateDirectory, to: packageDirectory)

  let testFile = packageDirectory.appendingPathComponent("Tests/TestTarget/test.swift")
  try code.write(to: testFile, atomically: true, encoding: .utf8)

  let response = try await execute(packageDirectory)
  try fileManager.removeItem(at: temporaryDirectory)
  return response
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

private func runProcess(_ launchPath: String, arguments: [String], workingDirectory: URL) async throws -> (status: Int32, stdout: String, stderr: String) {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: launchPath)
  process.arguments = arguments
  process.currentDirectoryURL = workingDirectory

  let output = Pipe()
  let error = Pipe()
  process.standardOutput = output
  process.standardError = error

  return try await withCheckedThrowingContinuation { (continuation) in
    process.terminationHandler = {
      let stdout = String(decoding: output.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
      let stderr = String(decoding: error.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
      continuation.resume(returning: ($0.terminationStatus, stdout, stderr))
    }

    do {
      try process.run()
    } catch {
      continuation.resume(throwing: error)
    }
  }
}

private struct MacroExpansionRequest: Codable {
  let code: String
}

private struct MacroExpansionResponse: Content {
  let stdout: String
  let stderr: String
}
