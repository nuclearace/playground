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

