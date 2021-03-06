//
// Created by Erik Little on 10/24/19.
//

import ArgumentParser
import BigInt
import Foundation

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

func stringFromTimeInterval(_ interval: TimeInterval) -> String {
  let interval = Int(interval)
  let seconds = interval % 60
  let minutes = (interval / 60) % 60
  let hours = (interval / 3600)

  return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

extension BigInt: ExpressibleByArgument {
  public init?(argument: String) {
    self.init(argument)
  }
}

protocol DefaultInit {
  init()
}

func with<T: DefaultInit>(new thing: T.Type, do: (inout T) -> ()) -> T {
  var t = thing.init()

  `do`(&t)

  return t
}
