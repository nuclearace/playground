//
// Created by Erik Little on 2019-09-19.
//

import ArgumentParser
import Foundation
import Playground

#if os(macOS)
import BigInt

typealias CollatzType = BigInt
#else
typealias CollatzType = Int
#endif

typealias InterestingN = (n: Int, found: Int)

enum Mode {
  case random
  case peakSearch
}

struct InterestingCollatz: CustomStringConvertible {
  var n = CollatzType(1)
  var iteration = 1
  var peak = CollatzType(1)
  var seriesCount = 1

  var description: String {
    return "n: \(n); series length: \(seriesCount); peak: \(peak); found: \(iteration)"
  }
}

private let timer = DispatchSource.makeTimerSource()

private var start: TimeInterval!
private var ranges: [ClosedRange<Int>]!
private var mode = Mode.random
private var lastInterestingThing = Date().timeIntervalSince1970
private var rng = MTRandom()
private var i = 1
private var peakN = CollatzType(1)
private var addRandom = false
private var increment = 100_000_000
private var longestSeries: InterestingCollatz!
private var largestN: InterestingCollatz!
private var largestPeak: InterestingCollatz!

private var shortestSeries: InterestingCollatz!
private var smallestPeak: InterestingCollatz!
private var smallestN: InterestingCollatz!

func getN() -> (CollatzType, String) {
  switch mode {
  case .peakSearch:
    let add: CollatzType

    if addRandom {
      add = CollatzType(Int.random(in: 1...increment, using: &rng))
    } else {
      add = 1
    }

    let str = "\(i): n = \(peakN) + \(add)"

    peakN += add

    return (peakN, str)
  case _:
    let range = ranges.randomElement(using: &rng)!
    let n = CollatzType(Int.random(in: range))

    return (n, "\(i): n = \(n) from range \(range)")
  }
}

func calculateInterestingThings(n: CollatzType, seriesCount: Int, peak: CollatzType) {
  let interesting = InterestingCollatz(n: n, iteration: i, peak: peak, seriesCount: seriesCount)
  var wasInteresting = false

  if longestSeries == nil {
    // set first iteration
    longestSeries = interesting
    largestN = interesting
    largestPeak = interesting

    shortestSeries = interesting
    smallestPeak = interesting
    smallestN = interesting
    lastInterestingThing = Date().timeIntervalSince1970

    return
  }

  if mode == .random {
    if n > largestN.n {
      print("\(i): New largest n")

      wasInteresting = true
      largestN = interesting
    } else if n < smallestN.n {
      print("\(i): New smallest n")

      wasInteresting = true
      smallestN = interesting
    }
  }

  if seriesCount > longestSeries.seriesCount {
    print("\(i): New longest series")

    wasInteresting = true
    longestSeries = interesting
  } else if seriesCount < shortestSeries.seriesCount {
    print("\(i): New shortest series")

    wasInteresting = true
    shortestSeries = interesting
  }

  if peak > largestPeak.peak {
    print("\(i): New largest peak")

    wasInteresting = true
    largestPeak = interesting
  } else if peak < smallestPeak.peak {
    print("\(i): New smallest peak")

    wasInteresting = true
    smallestPeak = interesting
  }

  if wasInteresting {
    lastInterestingThing = Date().timeIntervalSince1970
  }
}

func randomCollatz() -> TimeResult {
  let timeRunningStr = stringFromTimeInterval(Date().timeIntervalSince1970 - start)
  let lastInterestingStr = stringFromTimeInterval(Date().timeIntervalSince1970 - lastInterestingThing)
  let (n, nStr) = getN()
  let ((series, peak), t) = ClockTimer.time({ collatz(n) })

  print("\u{001B}[2J\u{001B}[f", terminator: "")
  print("Starting \(i); Time running: \(timeRunningStr); Time since last interesting thing: \(lastInterestingStr)")
  print(nStr)
  print("\(i): series length: \(series.count); peak: \(peak)")
  print()

  calculateInterestingThings(n: n, seriesCount: series.count, peak: peak)
  print()

  print("\(i): \(mode == .random ? "Largest" : "Starting") n = \(largestN!)")
  print("\(i): Longest Series = \(longestSeries!)")
  print("\(i): Largest Peak = \(largestPeak!)")
  print()
  print("\(i): \(mode == .random ? "Smallest" : "Starting") = \(smallestN!)")
  print("\(i): Shortest Series = \(shortestSeries!)")
  print("\(i): Smallest Peak = \(smallestPeak!)\n")
  print("\(i): Collatz took \(t.duration)s")

  return t
}

struct Collatzing: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Randomly puts numbers through the Collatz function and tracks results",
    subcommands: [Peak.self, Random.self]
  )

  static func collatz(delay: Int) {
    start = Date().timeIntervalSince1970

    timer.setEventHandler {
      let (collatzT, t) = ClockTimer.time(randomCollatz)
      let overhead = (t.duration - collatzT.duration) / t.duration

      print("\(i): Overall took \(t.duration)s; Overhead: \(String(format: "%.2f", overhead * 100))%")

      i += 1
    }

    timer.schedule(deadline: .now(), repeating: .milliseconds(delay))
    timer.activate()

    dispatchMain()
  }
}

extension Collatzing {
  struct Random: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "random",
      abstract: "Randomly goes through the range 1...Int.max, while splitting into ranges"
    )

    @Option(
      name: .shortAndLong,
      default: 50_000,
      help: "The number of ranges to split 1...Int.max into"
    )
    var numRanges: Int

    @Option(
      name: .shortAndLong,
      default: 5,
      help: "The number of ms between runs"
    )
    var timeDelay: Int

    func validate() throws {
      guard numRanges >= 1 else {
        throw RandomError.badNumRange
      }

      guard timeDelay > 0 else {
        throw RandomError.badTime
      }
    }

    func run() throws {
      ranges = createRanges(numRanges: numRanges)

      collatz(delay: timeDelay)
    }

    enum RandomError: Error {
      case badNumRange
      case badTime
    }
  }
}

extension Collatzing {
  struct Peak: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "peak",
      abstract: "Searches for peaks (i.e. largest values reached in a progression) starting at numStart"
    )

    @Option(
      name: .shortAndLong,
      default: 100_000_000,
      help: "Upper bound for choosing random increment"
    )
    var bound: Int

    @Option(
      name: .shortAndLong,
      default: 1,
      help: "The starting value of n"
    )
    var numStart: CollatzType

    @Flag(
      name: .shortAndLong,
      help: "Sets the increment to a random value, bounded by incrementUpperBound "
    )
    var randomIncrement: Bool

    @Option(
      name: .shortAndLong,
      default: 5,
      help: "The number of ms between runs"
    )
    var timeDelay: Int

    func run() throws {
      mode = .peakSearch
      peakN = numStart
      addRandom = randomIncrement
      increment = bound

      collatz(delay: timeDelay)
    }

    func validate() throws {
      guard numStart >= 1 else {
        throw PeakError.badN
      }

      guard bound >= 1 else {
        throw PeakError.badBound
      }

      guard timeDelay > 0 else {
        throw PeakError.badTime
      }
    }

    enum PeakError: Error {
      case badBound, badN, badTime
    }
  }
}

Collatzing.main()
