import BigInt
import CStuff
import Foundation
import Playground

var samples = [Double]()
var rng = MTRandom(seed: .random(in: UInt64.min...UInt64.max))

for _ in 0..<1_000_000 {
  samples.append(.random(in: -100.0...100.0, using: &rng))
}

let mean = samples.reduce(0, +) / Double(samples.count)

let (d, t): (Double, TimeResult) = ClockTimer.time {
  return (samples.map({ ($0 - mean) * ($0 - mean) }).reduce(0, +) / (Double(samples.count - 1))).squareRoot()
}

let (x, t2): (Double, TimeResult) = ClockTimer.time {
  return (samples.map({ pow(($0 - mean), 2) }).reduce(0, +) / (Double(samples.count - 1))).squareRoot()
}

print(d, t)
print(x, t2)
