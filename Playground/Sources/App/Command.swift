import Foundation

actor Command {
  private let process = Process()
  
  private let launchPath: String
  private let arguments: [String]
  private let workingDirectory: URL?

  init(launchPath: String, arguments: [String], workingDirectory: URL? = nil) {
    self.launchPath = launchPath
    self.arguments = arguments
    self.workingDirectory = workingDirectory
  }

  func run() throws -> CommandOutput {
    process.environment = ["NSUnbufferedIO": "YES"]
    process.executableURL = URL(fileURLWithPath: launchPath)
    process.arguments = arguments
    process.currentDirectoryURL = workingDirectory

    let standardOutput = Pipe()
    let standardError = Pipe()

    process.standardOutput = standardOutput
    process.standardError = standardError

    process.terminationHandler = { (process) in
      standardOutput.fileHandleForReading.readabilityHandler = nil
      standardError.fileHandleForReading.readabilityHandler = nil
    }

    try process.run()

    return CommandOutput(
      stdout: standardOutput.fileHandleForReading.bytes.lines,
      stderr: standardError.fileHandleForReading.bytes.lines
    )
  }

  func waitUntilExit() -> Int {
    process.waitUntilExit()
    return Int(process.terminationStatus)
  }
}

struct CommandStatus {
  let code: Int
  let isSuccess: Bool
  let stdout: String
  let stderr: String

  init(code: Int, stdout: String, stderr: String) {
    self.code = code
    isSuccess = code == 0
    self.stdout = stdout
    self.stderr = stderr
  }
}

struct CommandOutput {
  let stdout: AsyncLineSequence<FileHandle.AsyncBytes>
  let stderr: AsyncLineSequence<FileHandle.AsyncBytes>

  init(stdout: AsyncLineSequence<FileHandle.AsyncBytes>, stderr: AsyncLineSequence<FileHandle.AsyncBytes>) {
    self.stdout = stdout
    self.stderr = stderr
  }
}
