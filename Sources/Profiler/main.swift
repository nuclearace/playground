
import ArgumentParser
import ClockTimer
import Foundation

struct Profiler: ParsableCommand {
  @Argument(help: "The program to profile")
  var command: [String]

  @Flag(name: .shortAndLong, help: "Quiet mode. Print less output from profiler")
  var quiet: Bool

  @Flag(name: .shortAndLong, help: "Verbose mode. Print output from program")
  var verbose: Bool

  @Option(name: .shortAndLong, default: 10, help: "The number of times to run the program")
  var runTimes: Int

  mutating func validate() throws {
    guard runTimes > 0 else {
      throw ProfilerError.badRunTimes("You must provide a positive run time")
    }

    guard !command.isEmpty else {
      throw ProfilerError.noProgram("You must provide a program to run")
    }

    command = command.map({ $0.replacingOccurrences(of: "\\", with: "") })
  }

  func run() throws {
    var childFDActions: posix_spawn_file_actions_t?

    posix_spawn_file_actions_init(&childFDActions)

    if !verbose {
      _ = "/dev/null".withCString {strPtr in
        posix_spawn_file_actions_addopen(&childFDActions, 1, strPtr, O_WRONLY | O_CREAT | O_TRUNC, 0644)
      }
    }

    var program = command.first!

    if !program.hasPrefix("/") && !program.hasPrefix(".") {
      print("Looking up \(program)")

      guard let foundCommand = whichCommand(program) else {
        fatalError("Could not find \(program) to run")
      }

      print("found \(foundCommand)")

      program = foundCommand
    }

    let argv = ([program] + command.dropFirst()).map({ $0.withCString(strdup) })

    defer {
      for arg in argv {
        free(arg)
      }
    }

    print("Running \(command)")

    var times = [Double]()
    let start = Date().timeIntervalSince1970

    for i in 0..<runTimes {
      var pid: pid_t = 0

      let (keep, t) = ClockTimer.time {() -> Bool in
        let status = program.withCString {str in
          posix_spawn(&pid, str, &childFDActions, nil, argv + [nil], environ)
        }

        guard status == 0 else {
          fatalError("Could not spawn process")
        }

        guard waitpid(pid, nil, 0) == pid else {
          print("Run \(i + 1) errored")

          return false
        }

        return true
      }

      if !quiet || (i + 1) % 10 == 0 {
        print("run \(i + 1) took \(t.duration)s")
      }

      if keep {
        times.append(t.duration)
      }
    }

    let finish = Date().timeIntervalSince1970

    print()
    print("Number of runs: \(runTimes)")
    print("Minimum: \(times.min()!)")
    print("Maximum: \(times.max()!)")
    print("Average: \(times.reduce(0, +) / Double(times.count))s")
    print("Standard Deviation: \(stdDev(samples: times))")
    print("Total test time: \(finish - start)")
  }

  enum ProfilerError: Error {
    case badRunTimes(String), noProgram(String)
  }
}

Profiler.main()

