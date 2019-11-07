import BigInt
import CStuff
import Foundation
import Playground



let blinker = [Cell(x: 1, y: 0), Cell(x: 1, y: 1), Cell(x: 1, y: 2)] as Set

var col = Colony(cells: blinker, height: 3, width: 3)

print("Blinker: ")
col.run(iterations: 3)

let glider = [
  Cell(x: 1, y: 0),
  Cell(x: 2, y: 1),
  Cell(x: 0, y: 2),
  Cell(x: 1, y: 2),
  Cell(x: 2, y: 2)
] as Set

col = Colony(cells: glider, height: 8, width: 8)

print("Glider: ")
col.run(iterations: 20)
