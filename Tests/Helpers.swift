import XCTest

func captureConsoleOutput(execute: () -> Void, completion: @escaping (String) -> Void) {
  let pipe = Pipe()
  var output = ""

  let semaphore = XCTestExpectation(description: "semaphore")
  pipe.fileHandleForReading.readabilityHandler = { fileHandle in
    let data = fileHandle.availableData
    if data.isEmpty  {
      fileHandle.readabilityHandler = nil
      completion(output)
      semaphore.fulfill()
    } else {
      if let string = String(data: data,  encoding: .utf8) {
        output += string
      }
    }
  }

  setvbuf(stdout, nil, _IONBF, 0)
  let stdout = dup(STDOUT_FILENO)
  dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

  execute()

  dup2(stdout, STDOUT_FILENO)
  try? pipe.fileHandleForWriting.close()
  close(stdout)

  if XCTWaiter.wait(for: [semaphore]) != .completed {
    XCTFail("timeout")
  }
}

func captureConsoleOutput(execute: () throws -> Void, completion: @escaping (String) -> Void) throws {
  let pipe = Pipe()
  var output = ""

  let semaphore = XCTestExpectation(description: "semaphore")
  pipe.fileHandleForReading.readabilityHandler = { fileHandle in
    let data = fileHandle.availableData
    if data.isEmpty  {
      fileHandle.readabilityHandler = nil
      completion(output)
      semaphore.fulfill()
    } else {
      if let string = String(data: data,  encoding: .utf8) {
        output += string
      }
    }
  }

  setvbuf(stdout, nil, _IONBF, 0)
  let stdout = dup(STDOUT_FILENO)
  dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

  try execute()

  dup2(stdout, STDOUT_FILENO)
  try? pipe.fileHandleForWriting.close()
  close(stdout)

  if XCTWaiter.wait(for: [semaphore]) != .completed {
    XCTFail("timeout")
  }
}

func captureConsoleOutput(execute: () async -> Void, completion: @escaping (String) -> Void) async {
  let pipe = Pipe()

  class OutputRef {
    var output = ""
  }
  let ref = OutputRef()

  let semaphore = XCTestExpectation(description: "semaphore")
  pipe.fileHandleForReading.readabilityHandler = { fileHandle in
    let data = fileHandle.availableData
    if data.isEmpty  {
      fileHandle.readabilityHandler = nil
      completion(ref.output)
      semaphore.fulfill()
    } else {
      if let string = String(data: data,  encoding: .utf8) {
        ref.output += string
      }
    }
  }

  setvbuf(stdout, nil, _IONBF, 0)
  let stdout = dup(STDOUT_FILENO)
  dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

  await execute()

  dup2(stdout, STDOUT_FILENO)
  try? pipe.fileHandleForWriting.close()
  close(stdout)

  if await XCTWaiter.fulfillment(of: [semaphore]) != .completed {
    XCTFail("timeout")
  }
}

func captureConsoleOutput(execute: () async throws -> Void, completion: @escaping (String) -> Void) async throws {
  let pipe = Pipe()

  class OutputRef {
    var output = ""
  }
  let ref = OutputRef()

  let semaphore = XCTestExpectation(description: "semaphore")
  pipe.fileHandleForReading.readabilityHandler = { fileHandle in
    let data = fileHandle.availableData
    if data.isEmpty  {
      fileHandle.readabilityHandler = nil
      completion(ref.output)
      semaphore.fulfill()
    } else {
      if let string = String(data: data,  encoding: .utf8) {
        ref.output += string
      }
    }
  }

  setvbuf(stdout, nil, _IONBF, 0)
  let stdout = dup(STDOUT_FILENO)
  dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)

  try await execute()

  dup2(stdout, STDOUT_FILENO)
  try? pipe.fileHandleForWriting.close()
  close(stdout)

  if await XCTWaiter.fulfillment(of: [semaphore]) != .completed {
    XCTFail("timeout")
  }
}

/// Skips this test.
///
/// Directly using `throw XCTSkip()` will cause a warning on the next line:
/// ```txt
/// Code after 'throw' will never be executed
/// ```
///
/// This simpler wrapper makes the throwing opaque, and prevents the warning.
func skip(_ message: String? = nil, file: StaticString = #filePath, line: UInt = #line) throws {
  throw XCTSkip(message, file: file, line: line)
}
