import BigInt
import CStuff
import Playground

var line = PointLine(points: [
  Point(x: 0, y: 0),
  Point(x: 1, y: 0.1),
  Point(x: 2, y: -0.1),
  Point(x: 3, y: 5),
  Point(x: 4, y: 6),
  Point(x: 5, y: 7),
  Point(x: 6, y: 8.1),
  Point(x: 7, y: 9),
  Point(x: 8, y: 9),
  Point(x: 9, y: 9)
])

line.simplify()

print(line)
