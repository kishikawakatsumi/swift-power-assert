import Foundation
import TSCBasic

actor Command {
  private let process: TSCBasic.Process

  init(_ arguments: [String], workingDirectory: URL, onOutput: @escaping (String) -> Void, onError: @escaping (String) -> Void) {
    process = TSCBasic.Process(
      arguments: arguments,
      environment: [
        "NSUnbufferedIO": "YES",
        "TERM": "xterm-256color",
        "LD_PRELOAD": "./faketty.so",
      ],
      workingDirectory: try! AbsolutePath.init(validating: workingDirectory.path),
      outputRedirection: .stream(
        stdout: { (byte) in
          onOutput(String(decoding: byte, as: UTF8.self))
        }, stderr: { (byte) in
          onError(String(decoding: byte, as: UTF8.self))
        }
      )
    )
  }

  func run(onOutput: @escaping (String) -> Void = { _ in }, onError: @escaping (String) -> Void = { _ in }) async throws -> CommandStatus {
    try process.launch()
    let processResult = try await process.waitUntilExit()
    switch processResult.exitStatus {
    case .terminated(code: let code):
      return CommandStatus(
        code: code,
        stdout: (try? processResult.utf8Output()) ?? "",
        stderr: (try? processResult.utf8stderrOutput()) ?? ""
      )
    case .signalled:
      return CommandStatus(
        code: -1,
        stdout: (try? processResult.utf8Output()) ?? "",
        stderr: (try? processResult.utf8stderrOutput()) ?? ""
      )
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
