import BigInt
import CStuff
import Foundation
import Playground

var samples = [Double]()
var rng = MTRandom(seed: .random(in: UInt64.min...UInt64.max))

for _ in 0..<1_000 {
  samples.append(.random(in: -50.0...50.0, using: &rng))
}

let (d, t): (Double, TimeResult) = ClockTimer.time {
  let mean = samples.reduce(0, +) / Double(samples.count)

  return (samples.map({ ($0 - mean) * ($0 - mean) }).reduce(0, +) / (Double(samples.count - 1))).squareRoot()
}

let (x, t2): (Double, TimeResult) = ClockTimer.time {
  let mean = samples.reduce(0, +) / Double(samples.count)

  return (samples.map({ pow(($0 - mean), 2) }).reduce(0, +) / (Double(samples.count - 1))).squareRoot()
}


print(d, t)
print(x, t2)
