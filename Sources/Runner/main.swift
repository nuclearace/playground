import BigInt
import CStuff
import Foundation
import Playground

let gliderGun = [
  Cell(x: 1, y: 5),
  Cell(x: 1, y: 6),
  Cell(x: 2, y: 5),
  Cell(x: 2, y: 6),

  Cell(x: 11, y: 5),
  Cell(x: 11, y: 6),
  Cell(x: 11, y: 7),
  Cell(x: 12, y: 8),
  Cell(x: 13, y: 9),
  Cell(x: 14, y: 9),
  Cell(x: 12, y: 4),
  Cell(x: 13, y: 3),
  Cell(x: 14, y: 3),

  Cell(x: 15, y: 6),

  Cell(x: 16, y: 4),
  Cell(x: 17, y: 5),
  Cell(x: 17, y: 6),
  Cell(x: 17, y: 7),
  Cell(x: 16, y: 8),
  Cell(x: 18, y: 6),

  Cell(x: 21, y: 3),
  Cell(x: 21, y: 4),
  Cell(x: 21, y: 5),
  Cell(x: 22, y: 3),
  Cell(x: 22, y: 4),
  Cell(x: 22, y: 5),

  Cell(x: 23, y: 2),
  Cell(x: 23, y: 6),

  Cell(x: 25, y: 1),
  Cell(x: 25, y: 2),

  Cell(x: 25, y: 6),
  Cell(x: 25, y: 7),

  Cell(x: 36, y: 3),
  Cell(x: 36, y: 4),
  Cell(x: 35, y: 3),
  Cell(x: 35, y: 4),
] as Set

var col = Colony(cells: gliderGun, height: 50, width: 100)

col.printColony()
//col.run(iterations: 300)

