import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

//let l1 = [3, 2, 6, 4, 5, 1]
//let l2 = [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]
//
//print("\(l1) = \(l1.longestIncreasingSubsequence())")
//print("\(l2) = \(l2.longestIncreasingSubsequence())")

do {
  var rng = MTRandom()

  let arr = Array(1...1_000_000)

  let (shuffled, t1) = ClockTimer.time { arr.shuffled(using: &rng) }

  print("Shuffling took \(t1.duration)s")

  let (lis, t2) = ClockTimer.time { shuffled.longestIncreasingSubsequence() }

  print("Took \(t2.duration)s to find longest increasing subsequence of len \(lis.count)")
}

