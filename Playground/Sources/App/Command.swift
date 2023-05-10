import Foundation
import TSCBasic

class Command {
  private let arguments: [String]
  private let workingDirectory: URL

  init(_ arguments: [String], workingDirectory: URL) {
    self.arguments = arguments
    self.workingDirectory = workingDirectory
  }

  func run(onOutput: @escaping (String) -> Void, onError: @escaping (String) -> Void) async throws -> CommandStatus {
    var stdout = ""
    var stderr = ""

    let process = TSCBasic.Process(
      arguments: arguments,
      environment: [
        "NSUnbufferedIO": "YES",
        "TERM": "xterm-256color",
        "LD_PRELOAD": "./faketty.so",
      ],
      workingDirectory: try! AbsolutePath.init(validating: workingDirectory.path),
      outputRedirection: .stream(
        stdout: { (byte) in
          let output = String(decoding: byte, as: UTF8.self)
          stdout += output
          onOutput(output)
        }, stderr: { (byte) in
          let output = String(decoding: byte, as: UTF8.self)
          stderr += output
          onError(output)
        }
      )
    )

    try process.launch()
    let processResult = try await process.waitUntilExit()
    switch processResult.exitStatus {
    case .terminated(code: let code):
      return CommandStatus(code: code, stdout: stdout, stderr: stderr)
    case .signalled(signal: let signal):
      return CommandStatus(code: signal, stdout: stdout, stderr: stderr)
    }
  }
}

struct CommandStatus {
  let code: Int
  let isSuccess: Bool
  let stdout: String
  let stderr: String

  init(code: Int32, stdout: String, stderr: String) {
    self.code = Int(code)
    isSuccess = code == 0
    self.stdout = stdout
    self.stderr = stderr
  }
}
