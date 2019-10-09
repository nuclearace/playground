import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let b = KnightsTour(size: 8)

print()

let completed = b.tour(startingAt: CPoint(x: 3, y: 1))

if completed {
  print("Completed tour")
} else {
  print("Did not complete tour")
}

b.printBoard()
