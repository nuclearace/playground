import BigInt
import CStuff
import Foundation
import Playground

var draw = BitmapDrawer(height: 900, width: 1440)
let l1 = Line(p1: Point(x: 400, y: 550), p2: Point(x: 200, y: 400))
let l2 = Line(p1: Point(x: 400, y: 550), p2: Point(x: 600, y: 400))
let l3 = Line(p1: Point(x: 200, y: 400), p2: Point(x: 350, y: 150))
let l4 = Line(p1: Point(x: 600, y: 400), p2: Point(x: 450, y: 150))
let l5 = Line(p1: Point(x: 350, y: 150), p2: Point(x: 450, y: 150))
let l6 = Line(p1: Point(x: 400, y: 550), p2: Point(x: 400, y: 150))

print(l1)
print(l2)
print(l3)
print(l4)
print(l5)
print(l6)


l1.draw(into: &draw)
l2.draw(into: &draw)
l3.draw(into: &draw)
l4.draw(into: &draw)
l5.draw(into: &draw)
l6.draw(into: &draw)

draw.drawGrid()
draw.save()
