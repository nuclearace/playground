//
// Created by Erik Little on 2019-09-19.
//

import Commander
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

func createRanges(numRanges: Int, max: Int = .max) -> [ClosedRange<Int>] {
  let perRange = max / numRanges
  var ranges = [ClosedRange<Int>]()

  var startN = 0

  for _ in 0..<numRanges-1 {
    startN += 1

    // print("range \(i) starts at \(startN) and ends at \(startN+perRange)")
    ranges.append(startN...startN+perRange)

    startN += perRange
  }

  return ranges + [startN+1...max]
}

private let timer = DispatchSource.makeTimerSource()

private var start: TimeInterval!
private var ranges: [ClosedRange<Int>]!
private var mode = Mode.random
private var lastInterestingThing = Date().timeIntervalSince1970
private var rng = MTRandom()
private var i = 1
private var peakN = CollatzType(1)
private var longestSeries: InterestingCollatz!
private var largestN: InterestingCollatz!
private var largestPeak: InterestingCollatz!

private var shortestSeries: InterestingCollatz!
private var smallestPeak: InterestingCollatz!
private var smallestN: InterestingCollatz!

func getN() -> CollatzType {
  switch mode {
  case .peakSearch:
    print("\(i): n = \(peakN)")

    peakN += 1

    return peakN
  case _:
    let range = ranges.randomElement(using: &rng)!
    let n = CollatzType(Int.random(in: range))

    print("\(i): n = \(n) from range \(range)")

    return n
  }
}

func stringFromTimeInterval(_ interval: TimeInterval) -> String {
  let interval = Int(interval)
  let seconds = interval % 60
  let minutes = (interval / 60) % 60
  let hours = (interval / 3600)

  return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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

func randomCollatz() {
  let n = getN()
  let (series, peak) = collatz(CollatzType(n))

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
  print("\(i): Smallest Peak = \(smallestPeak!)")
}

let collatzing = command(
  Option("peak", default: -1, flag: "p", description: "peak search, starting at n (default 1)"),
  Option("random", default: 50_000, flag: "r", description: "number of ranges for random search")
) {n, numRanges in
  if n > 0 {
    print("doing peak search starting at \(n)")

    mode = .peakSearch
    peakN = CollatzType(n)
  } else {
    print("random search with num ranges \(numRanges)")

    ranges = createRanges(numRanges: numRanges)
  }

  start = Date().timeIntervalSince1970

  timer.setEventHandler {
    let timeRunningStr = stringFromTimeInterval(Date().timeIntervalSince1970 - start)
    let lastInterestingStr = stringFromTimeInterval(Date().timeIntervalSince1970 - lastInterestingThing)

    print("\u{001B}[2J\u{001B}[f", terminator: "")
    print("Starting \(i); Time running: \(timeRunningStr); Time since last interesting thing: \(lastInterestingStr)")

    let (_, t) = ClockTimer.time(randomCollatz)

    print("\(i): took \(t.duration)s")

    i += 1
  }

  timer.schedule(deadline: .now(), repeating: .milliseconds(5))
  timer.activate()

  dispatchMain()
}

collatzing.run()

