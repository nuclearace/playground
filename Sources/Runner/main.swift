import BigInt
import CStuff
import Foundation
import Playground

var points = [Point]()

for _ in 0..<1_000 {
  points.append(Point(x: .random(in: -10...10), y: .random(in: -10...10)))
}

guard case let (pair?, t) = ClockTimer.time({
  return points.closestPairBruteForce()
}) else {
  fatalError()
}

print(pair.1, t)
print(abs(pair.1.0.distance(to: pair.1.1)))

guard case let (pairFast?, tFast) = ClockTimer.time({
  return points.closestPair()
}) else {
  fatalError()
}

print(pairFast, tFast)
print(abs(pairFast.0.distance(to: pairFast.1)))

guard abs(pair.1.0.distance(to: pair.1.1)) == abs(pairFast.0.distance(to: pairFast.1)) else {
  fatalError("Differing distances for \(points)")
}
