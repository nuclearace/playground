import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

var count = 0
var rng = MTRandom()
var arr = Array(-100_000...100_000)
var shuffleTime = 0.0

while true {
  let (_, t) = ClockTimer.time {
    arr.shuffle(using: &rng)
  }

  shuffleTime += t.duration

  let idxs = arr.equilibriumIndexes()

  guard !idxs.isEmpty else {
    count += 1

    continue
  }

  print(idxs, count, "\(shuffleTime)s shuffling")
  break
}


