import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

guard let sim = NBody(file: "/Users/erik.little/Desktop/input.txt") else {
  fatalError()
}

print()
print("Body   :      x          y          z    |     vx         vy         vz")

for i in 0..<sim.timeSteps {
  print("Step \(i + 1)")
  sim.simulate()
  sim.printState()
  print()
}
