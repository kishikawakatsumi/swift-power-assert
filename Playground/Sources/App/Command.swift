import Foundation

struct Command {
  let launchPath: String
  let arguments: [String]
  let workingDirectory: URL?

  init(launchPath: String, arguments: [String], workingDirectory: URL? = nil) {
    self.launchPath = launchPath
    self.arguments = arguments
    self.workingDirectory = workingDirectory
  }

  func run() async throws -> CommandOutput {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: launchPath)
    process.arguments = arguments
    process.currentDirectoryURL = workingDirectory

    let standardOutput = Pipe()
    let standardError = Pipe()

    process.standardOutput = standardOutput
    process.standardError = standardError
    
    return try await withCheckedThrowingContinuation { (continuation) in
      process.terminationHandler = { (process) in
        let stdout = String(decoding: standardOutput.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
        let stderr = String(decoding: standardError.fileHandleForReading.readDataToEndOfFile(), as: UTF8.self)
        continuation.resume(
          returning: CommandOutput(
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
}

struct CommandOutput {
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
