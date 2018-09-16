//
// Created by Erik Little on 9/16/18.
//

struct Point {
  var x: Double
  var y: Double
}

struct Line {
  var p1: Point
  var p2: Point

  var slope: Double {
    guard p1.x - p2.x != 0.0 else { return .nan }

    return (p1.y-p2.y) / (p1.x-p2.x)
  }

  var yIntercept: Double {
    return p1.y - slope * p1.x
  }

  func intersection(of other: Line) -> Point? {
    let ourSlope = slope
    let theirSlope = other.slope

    guard ourSlope != theirSlope else { return nil }

    if ourSlope.isNaN && !theirSlope.isNaN {
      return Point(x: p1.x, y: (p1.x - other.p1.x) * theirSlope + other.p1.y)
    } else if theirSlope.isNaN && !ourSlope.isNaN {
      return Point(x: other.p1.x, y: (other.p1.x - p1.x) * ourSlope + other.p1.y)
    } else {
      let x = (ourSlope*p1.x - theirSlope*other.p1.x + other.p1.y - p1.y) / (ourSlope - theirSlope)
      return Point(x: x, y: theirSlope*(x - other.p1.x) + other.p1.y)
    }
  }
}

extension Line : CustomStringConvertible {
  var description: String {
    let s = slope
    let yI = yIntercept

    guard !s.isNaN else { return "x = \(p1.x)" }
    guard abs(s) != 0 else { return "y = \(p1.y)" }

    let sign = yI >= 0 ? "+" : "-"
    return "y = \(s)x \(sign) \(abs(yI))"
  }
}

