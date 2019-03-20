//
// Created by Erik Little on 2019-03-20.
//

import Foundation

func whichCommand(_ command: String) -> String? {
  let p = Process()
  let out = Pipe()

  p.arguments = [command]
  p.standardOutput = out

  if #available(OSX 10.13, *) {
      p.executableURL = URL(string: "file:///usr/bin/which")!
  } else {
      p.launchPath = "/usr/bin/which"
  }

  p.launch()
  p.waitUntilExit()

  let res = out.fileHandleForReading.readDataToEndOfFile()

  guard !res.isEmpty, let command = String(data: res, encoding: .utf8) else {
    return nil
  }

  return command.replacingOccurrences(of: "\n", with: "")
}
