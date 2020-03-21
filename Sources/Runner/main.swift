import BigInt
import ClockTimer
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

let size = 1000
let numBarriers = (size * size) / 2

var rng = MTRandom()
var barriers: Barrier = []

while barriers.count != numBarriers {
  barriers.insert(
    GridPosition(x: .random(in: 0..<size, using: &rng), y: .random(in: 0..<size, using: &rng))
  )
}

var to = GridPosition(x: .random(in: 0..<size), y: .random(in: 0..<size))

while barriers.contains(to) {
  to = GridPosition(x: .random(in: 0..<size), y: .random(in: 0..<size))
}

print("Searching:...")

guard case let ((path, cost)?, t) = ClockTimer.time({
  aStarSearch(
    start: GridPosition(x: 0, y: 0),
    finish: to,
    grid: SquareGrid(height: size, width: size, barriers: [barriers])
  )
}) else {
  fatalError("No solution")
}

print("Found solution in \(t.duration)s\n")

print("Path length \(path)")
print("Cost: \(cost)")
