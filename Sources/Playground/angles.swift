//
// Created by Erik Little on 2019-07-17.
//

import Foundation

@inlinable
public func normalize<T: FloatingPoint>(_ f: T, N: T) -> T {
  var a = f

  while a < -N { a += N }
  while a >= N { a -= N }

  return a
}

@inlinable
public func normalizeToDeg<T: FloatingPoint>(_ f: T) -> T {
  return normalize(f, N: 360)
}

@inlinable
public func normalizeToGrad<T: FloatingPoint>(_ f: T) -> T {
  return normalize(f, N: 400)
}

@inlinable
public func normalizeToMil<T: FloatingPoint>(_ f: T) -> T {
  return normalize(f, N: 6400)
}

@inlinable
func normalizeToRad<T: FloatingPoint>(_ f: T) -> T {
  return normalize(f, N: 2 * .pi)
}

@inlinable public func d2g<T: FloatingPoint>(_ f: T) -> T { f * 10 / 9 }
@inlinable public func d2m<T: FloatingPoint>(_ f: T) -> T { f * 160 / 9 }
@inlinable public func d2r<T: FloatingPoint>(_ f: T) -> T { f * .pi / 180 }

@inlinable public func g2d<T: FloatingPoint>(_ f: T) -> T { f * 9 / 10 }
@inlinable public func g2m<T: FloatingPoint>(_ f: T) -> T { f * 16 }
@inlinable public func g2r<T: FloatingPoint>(_ f: T) -> T { f * .pi / 200 }

@inlinable public func m2d<T: FloatingPoint>(_ f: T) -> T { f * 9 / 160 }
@inlinable public func m2g<T: FloatingPoint>(_ f: T) -> T { f / 16 }
@inlinable public func m2r<T: FloatingPoint>(_ f: T) -> T { f * .pi / 3200 }

@inlinable public func r2d<T: FloatingPoint>(_ f: T) -> T { f * 180 / .pi }
@inlinable public func r2g<T: FloatingPoint>(_ f: T) -> T { f * 200 / .pi }
@inlinable public func r2m<T: FloatingPoint>(_ f: T) -> T { f * 3200 / .pi }

public func angleDifference(a1: Double, a2: Double) -> Double {
  let diff = (a2 - a1).truncatingRemainder(dividingBy: 360)

  if diff < -180.0 {
    return 360.0 + diff
  } else if diff > 180.0 {
    return -360.0 + diff
  } else {
    return diff
  }
}

public func meanOfAngles(_ angles: [Double]) -> Double {
  let cInv = 1 / Double(angles.count)
  let (y, x) =
    angles.lazy
      .map(d2r)
      .map({ (sin($0), cos($0)) })
      .reduce(into: (0.0, 0.0), { $0.0 += $1.0; $0.1 += $1.1 })

  return r2d(atan2(cInv * y, cInv * x))
}
