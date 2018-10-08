import Foundation

guard let command = CommandLine.arguments.dropFirst().first else {
  fatalError("Not enough arguments")
}

let runTimes: Int

if let stringTimes = CommandLine.arguments.filter({ $0.hasPrefix("-n=") }).first,
   let times = Int(stringTimes.dropFirst(3)) {
  runTimes = times
} else {
  runTimes = 10
}

guard runTimes > 0 else {
  fatalError("Must run at least once")
}

var times = [Double]()

for i in 0..<runTimes {
  let p = Process()

  p.standardInput = nil
  p.standardError = nil
  p.standardOutput = nil

  if #available(OSX 10.13, *) {
    p.executableURL = URL(fileURLWithPath: command)
  } else {
    p.launchPath = command
  }

  let s = clock()
  p.launch()
  p.waitUntilExit()

  let t = Double(clock() - s) / Double(CLOCKS_PER_SEC)

  print("run \(i + 1) took \(t)s")

  times.append(t)
}

print()
print("Minimum: \(times.min()!)")
print("Maximum: \(times.max()!)")
print("Average: \(times.reduce(0, +) / Double(times.count))s")
print("Standard Deviation: \(stdDev(samples: times))")
