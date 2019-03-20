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

var childFDActions: posix_spawn_file_actions_t?

posix_spawn_file_actions_init(&childFDActions)

if quiet {
  _ = "/dev/null".withCString {strPtr in
    posix_spawn_file_actions_addopen(&childFDActions, 1, strPtr, O_WRONLY | O_CREAT | O_TRUNC, 0644)
  }
}

let command = commandArgs.first!
var times = [Double]()

print("Running \(commandArgs)")

for i in 0..<runTimes {
  var pid: pid_t = 0

  let status = command.withCString {str in
    return posix_spawn(&pid, str, &childFDActions, nil, CommandLine.unsafeArgv.advanced(by: 2), environ)
  }

  guard status == 0 else {
    fatalError("Could not spawn process")
  }

  let s = Date().timeIntervalSince1970
  let returnCode = waitpid(pid, nil, 0)

  guard returnCode == pid else {
    print("Run \(i + 1) errored")

    continue
  }

  let t = Date().timeIntervalSince1970 - s

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
