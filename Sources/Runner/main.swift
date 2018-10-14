import BigInt
import CStuff
import Foundation
import Playground

let p = Percolate(height: 10, width: 10)

p.makeGrid(porosity: 0.5)
p.percolate()
p.showGrid()

print("Running \(p.height) x \(p.width) grid 10,000 times for each porosity")

for factor in 1...10 {
  var count = 0
  let porosity = Double(factor) / 10.0

  for _ in 0..<10_000 {
    p.makeGrid(porosity: porosity)

    if (p.percolate()) {
      count += 1
    }
  }

  print("p = \(porosity): \(Double(count) / 10_000.0)")
}
