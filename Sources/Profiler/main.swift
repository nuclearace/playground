import Foundation

let args = Array(CommandLine.arguments.dropFirst())

var quiet = false
var runTimes = 10
var commandArgs = [String]()

for (i, arg) in args.enumerated() {
  if arg == "-q" {
    quiet = true
  } else if arg.hasPrefix("-n=") {
    runTimes = Int(arg.dropFirst(3))!
  } else {
    commandArgs = Array(args.dropFirst(i))
    break
  }
}

guard runTimes > 0 else {
  fatalError("Must run at least once")
}

let command = commandArgs.first!
var times = [Double]()

for i in -1..<runTimes {
  let p = Process()

  p.standardInput = nil
  p.standardError = nil
  p.standardOutput = nil

  if #available(macOS 10.13, *) {
    p.executableURL = URL(fileURLWithPath: command)
  } else {
    p.launchPath = command
  }

  p.arguments = Array(commandArgs.dropFirst())

  let s = Date().timeIntervalSince1970
  p.launch()
  p.waitUntilExit()

  let t = Date().timeIntervalSince1970 - s

  // First result is skewed from Process setup overhead
  guard i >= 0 else { continue }

  if !quiet || (i + 1) % 10 == 0 {
    print("run \(i + 1) took \(t)s")
  }

  times.append(t)
}

print()
print("Minimum: \(times.min()!)")
print("Maximum: \(times.max()!)")
print("Average: \(times.reduce(0, +) / Double(times.count))s")
print("Standard Deviation: \(stdDev(samples: times))")
