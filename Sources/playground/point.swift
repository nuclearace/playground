//
// Created by Erik Little on 9/16/18.
//

import Foundation

public struct Point {
  public var x: Double
  public var y: Double

  public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }

  public func perpendicularDistance(to line: Line) -> Double {
    var dx = line.end.x - line.start.x
    var dy = line.end.y - line.start.y

    let mag = pow(pow(dx, 2.0) + pow(dy, 2.0), 0.5)

    if mag > 0.0 {
      dx /= mag
      dy /= mag
    }

    let pvx = x - line.start.x
    let pvy = y - line.start.y

    let pvDot = dx * pvx + dy * pvy

    let dsx = pvDot * dx
    let dsy = pvDot * dy

    let ax = pvx - dsx
    let ay = pvy - dsy

    return pow(pow(ax, 2.0) + pow(ay, 2.0), 0.5)
  }
}

public struct Line {
  public var start: Point
  public var end: Point

  public var slope: Double {
    guard start.x - end.x != 0.0 else { return .nan }

    return (start.y - end.y) / (start.x - end.x)
  }

  public var yIntercept: Double {
    return start.y - slope * start.x
  }

  public init(p1: Point, p2: Point) {
    self.start = p1
    self.end = p2
  }

  public func intersection(of other: Line) -> Point? {
    let ourSlope = slope
    let theirSlope = other.slope

    guard ourSlope != theirSlope else { return nil }

    if ourSlope.isNaN && !theirSlope.isNaN {
      return Point(x: start.x, y: (start.x - other.start.x) * theirSlope + other.start.y)
    } else if theirSlope.isNaN && !ourSlope.isNaN {
      return Point(x: other.start.x, y: (other.start.x - start.x) * ourSlope + other.start.y)
    } else {
      let x = (ourSlope * start.x - theirSlope*other.start.x + other.start.y - start.y) / (ourSlope - theirSlope)
      return Point(x: x, y: theirSlope*(x - other.start.x) + other.start.y)
    }
  }
}

extension Line : CustomStringConvertible {
  public var description: String {
    let s = slope
    let yI = yIntercept

    guard !s.isNaN else { return "x = \(start.x)" }
    guard abs(s) != 0 else { return "y = \(start.y)" }

    let sign = yI >= 0 ? "+" : "-"
    return "y = \(s)x \(sign) \(abs(yI))"
  }
}

extension Line : Drawable {
  private func drawLow<T: Drawer>(into drawer: inout T, start: Point, end: Point) {
    let dx = end.x - start.x
    var dy = end.y - start.y
    var yi = 1

    if dy < 0 {
      yi = -1
      dy *= -1
    }

    var d = 2*dy - dx
    var y = start.y

    for x in stride(from: start.x, to: end.x, by: 0.5) {
      drawer.setPixel(
          x: Int(x),
          y: Int(y),
          to: (255, 158, 22)
      )

      if d > 0 {
        y += Double(yi)
        d -= 2*dx
      }

      d += 2*dy
    }
  }

  private func drawHigh<T: Drawer>(into drawer: inout T, start: Point, end: Point) {
    var dx = end.x - start.x
    let dy = end.y - start.y
    var xi = 1

    if dx < 0 {
      xi = -1
      dx *= -1
    }

    var d = 2*dx - dy
    var x = start.x

    for y in stride(from: start.y, to: end.y, by: 0.5) {
      drawer.setPixel(
          x: Int(x),
          y: Int(y),
          to: (255, 158, 22)
      )

      if d > 0 {
        x += Double(xi)
        d -= 2*dy
      }

      d += 2*dx
    }
  }

  public func draw<T: Drawer>(into drawer: inout T) {
    guard start.x != end.x else {
      for y in stride(from: start.y, through: end.y, by: 0.5) {
        drawer.setPixel(x: Int(start.x), y: Int(y), to: (255, 158, 22))
      }

      return
    }

    if abs(end.y - start.y) < abs(end.x - start.x) {
      if start.x > end.x {
        drawLow(into: &drawer, start: end, end: start)
      } else {
        drawLow(into: &drawer, start: start, end: end)
      }
    } else {
      if start.y > end.y {
        drawHigh(into: &drawer, start: end, end: start)
      } else {
        drawHigh(into: &drawer, start: start, end: end)
      }
    }
  }
}

public struct PointLine {
  public var points: [Point]

  public init(points: [Point]) {
    self.points = points
  }

  public mutating func simplify(epsilon: Double = 1.0) {
    points = PointLine._simplify(epsilon: epsilon, points: points)
  }

  private static func _simplify(epsilon: Double, points: [Point]) -> [Point] {
    precondition(points.count >= 2, "Not enough points to simplify")

    let l = Line(p1: points.first!, p2: points.last!)

    // Find the point with the maximum distance from line between start and end
    var dMax = 0.0
    var index = 0

    for i in 1..<points.count-1 {
      let point = points[i]
      let d = point.perpendicularDistance(to: l)

      guard d > dMax else { continue }

      index = i
      dMax = d
    }

    guard dMax > epsilon else {
      return [l.start, l.end]
    }

    let res1 = _simplify(epsilon: epsilon, points: Array(points[...index]))
    let res2 = _simplify(epsilon: epsilon, points: Array(points[index...]))

    return res1.dropLast() + res2
  }
}

extension PointLine : Drawable {
  public func draw<T: Drawer>(into drawer: inout T) {
    let (oX, oY) = drawer.origin

    // FIXME this is horrible, need to figure out scaling stuff
    for point in points {
      drawer.setPixel(
          x: oX + Int(point.x.rounded()),
          y: oY + Int(point.y.rounded()),
          to: Color(red: 255, green: 158, blue: 22)
      )
    }
  }
}
