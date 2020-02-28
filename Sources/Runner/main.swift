import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

let sys = [
  [1.00, 0.00, 0.00, 0.00, 0.00, 0.00, -0.01],
  [1.00, 0.63, 0.39, 0.25, 0.16, 0.10, 0.61],
  [1.00, 1.26, 1.58, 1.98, 2.49, 3.13, 0.91],
  [1.00, 1.88, 3.55, 6.70, 12.62, 23.80, 0.99],
  [1.00, 2.51, 6.32, 15.88, 39.90, 100.28, 0.60],
  [1.00, 3.14, 9.87, 31.01, 97.41, 306.02, 0.02]
]

guard let sols = gaussEliminate(sys) else {
  fatalError("No solutions")
}

for (i, f) in sols.enumerated() {
  print("X\(i + 1) = \(f)")
}
