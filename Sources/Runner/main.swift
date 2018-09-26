import BigInt
import CStuff
import Foundation
import Playground

var drawer = BitmapDrawer(height: 1000, width: 1000)

func someFunc(x: Double) -> Double {
  return (14 * pow(x, 3)) + 2 * x + 5
}

var points = [Point]()

for d in stride(from: -1, through: 1, by: 0.1) {
  points.append(Point(x: d, y: someFunc(x: d)))
}

var line = PointLine(points: points)

line.draw(into: &drawer)

line.simplify(epsilon: 0.05)

line.draw(into: &drawer)

drawer.save()
