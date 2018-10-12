import BigInt
import CStuff
import Foundation
import Playground

var draw = BitmapDrawer(height: 500, width: 500)
let l1 = Line(p1: Point(x: 0, y: 0), p2: Point(x: 20, y: -200))
let l2 = Line(p1: Point(x: 0, y: 0), p2: Point(x: 100, y: 100))

print(l1)
print(l2)

l1.draw(into: &draw)
l2.draw(into: &draw)

draw.drawGrid()

draw.save()
