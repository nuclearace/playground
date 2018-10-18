//
// Created by Erik Little on 9/16/18.
//

import Foundation

public struct Point : Equatable, Hashable {
  public var x: Double
  public var y: Double

  public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }

  public func distance(to p: Point) -> Double {
    let x = pow(p.x - self.x, 2)
    let y = pow(p.y - self.y, 2)

    return (x + y).squareRoot()
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

extension Point : CustomStringConvertible {
  public var description: String {
    return "Point(x: \(x), y: \(y))"
  }
}

extension Collection where Element == Point {
  @inlinable
  public func closestPair() -> (Point, Point)? {
    guard count > 20 else { return closestPairBruteForce()?.1 }

    let (xP, xY) = (sorted(by: { $0.x < $1.x }), sorted(by: { $0.y < $1.y }))

    return Self.closestPair(xP, xY)?.1
  }

  @usableFromInline
  static func closestPair(_ xP: [Point], _ yP: [Point]) -> (Double, (Point, Point))? {
    guard xP.count > 20 else { return xP.closestPairBruteForce() }

    let half = xP.count / 2
    let xl = Array(xP[..<half])
    let xr = Array(xP[half...])
    let xm = xl.last!.x
    let (yl, yr) = yP.reduce(into: ([Element](), [Element]()), {cur, el in
      if el.x > xm {
        cur.1.append(el)
      } else {
        cur.0.append(el)
      }
    })

    guard let (distanceL, pairL) = closestPair(xl, yl) else { return nil }
    guard let (distanceR, pairR) = closestPair(xr, yr) else { return nil }

    let (dMin, pairMin) = distanceL > distanceR ? (distanceR, pairR) : (distanceL, pairL)

    let ys = yP.filter({ abs(xm - $0.x) < dMin })

    var (closest, pairClosest) = (dMin, pairMin)

    for i in 0..<ys.count {
      let p1 = ys[i]

      for k in i+1..<ys.count {
        let p2 = ys[k]

        guard abs(p2.y - p1.y) < dMin else { break }

        let distance = abs(p1.distance(to: p2))

        if distance < closest {
          (closest, pairClosest) = (distance, (p1, p2))
        }
      }
    }

    return (closest, pairClosest)
  }

  @inlinable
  public func closestPairBruteForce() -> (Double, (Point, Point))? {
    guard count >= 2 else { return nil }

    var closestPoints = (self.first!, self[index(after: startIndex)])
    var minDistance = abs(closestPoints.0.distance(to: closestPoints.1))

    guard count != 2 else { return (minDistance, closestPoints) }

    for i in 0..<count {
      let p1 = self[index(startIndex, offsetBy: i)]

      for j in i+1..<count {
        let p2 = self[index(startIndex, offsetBy: j)]

        let distance = abs(p1.distance(to: p2))

        if distance < minDistance {
          minDistance = distance
          closestPoints = (p1, p2)
        }
      }
    }

    return (minDistance, closestPoints)
  }
}

public struct Line : Equatable, Hashable {
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

    for x in stride(from: start.x, to: end.x, by: 1) {
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

    for y in stride(from: start.y, to: end.y, by: 1) {
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
      for y in stride(from: min(start.y, end.y), through: max(start.y, end.y), by: 1) {
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
