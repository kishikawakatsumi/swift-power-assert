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

    do {
      let eraser = MacroEraser()
      let output = try await runBuild(code: "\(eraser.rewrite(Syntax(sourceFile)))")
      guard output.isSuccess else {
        return MacroExpansionResponse(
          stdout: "",
          stderr: "\(output.stdout)\(output.stderr)"
        )
      }
    } catch {
      throw Abort(.internalServerError)
    }

    do {
      let context = BasicMacroExpansionContext(
        sourceFiles: [sourceFile: .init(moduleName: testModuleName, fullFilePath: testFileName)]
      )
      let output = try await runTest(code: "\(sourceFile.expand(macros: macros, in: context))")
      let response = MacroExpansionResponse(
        stdout: output.stdout,
        stderr: output.stderr
      )
      return response
    } catch {
      throw Abort(.internalServerError)
    }
  }
}

private func runBuild(code: String) async throws -> ProcessOutput {
  try await runInTemporaryDirectory(code: code) { (temporaryDirectory) in
    try await runProcess(
      "/usr/bin/env", arguments: ["swift", "build", "--build-tests"], workingDirectory: temporaryDirectory
    )
  }
}

private func runTest(code: String) async throws -> ProcessOutput {
  try await runInTemporaryDirectory(code: code) { (temporaryDirectory) in
    try await runProcess(
      "/usr/bin/env", arguments: ["swift", "test"], workingDirectory: temporaryDirectory
    )
  }
}

private func runProcess(_ launchPath: String, arguments: [String], workingDirectory: URL? = nil) async throws -> ProcessOutput {
  let process = Process()
  process.executableURL = URL(fileURLWithPath: launchPath)
  process.arguments = arguments
  process.currentDirectoryURL = workingDirectory

  let output = Pipe()
  let error = Pipe()
  process.standardOutput = output
  process.standardError = error
  return try await withCheckedThrowingContinuation { (continuation) in
    process.terminationHandler = { (process) in
      let stdout = String(decoding: output.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
      let stderr = String(decoding: error.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
      continuation.resume(
        returning: ProcessOutput(
          code: process.terminationStatus,
          stdout: stdout,
          stderr: stderr
        )
      )
    }

    do {
      try process.run()
    } catch {
      continuation.resume(throwing: error)
    }
  }
}

private func runInTemporaryDirectory(code: String, execute: (URL) async throws -> ProcessOutput) async throws -> ProcessOutput {
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
  let srcPath = srcURL.path(percentEncoded: false)
  let dstPath = dstURL.path(percentEncoded: false)

  let process = Process()
  process.executableURL = URL(fileURLWithPath: "/bin/cp")
  process.arguments = ["-R", "-L", srcPath, dstPath]

  try process.run()
  process.waitUntilExit()
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
  let code: String
}

private struct MacroExpansionResponse: Content {
  let stdout: String
  let stderr: String
}

private struct ProcessOutput {
  let code: Int32
  let stdout: String
  let stderr: String
  let isSuccess: Bool

  init(code: Int32, stdout: String, stderr: String) {
    self.code = code
    self.stdout = stdout
    self.stderr = stderr
    isSuccess = code == 0
  }
}
