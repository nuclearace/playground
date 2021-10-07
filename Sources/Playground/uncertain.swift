//
// Created by Erik Little on 10/7/21.
//

import Foundation

infix operator ±

public func ±(_ lhs: Double, _ rhs: Double) -> UncertainDouble { UncertainDouble(value: lhs, error: rhs) }

public struct UncertainDouble {
  public var value: Double
  public var error: Double

  public static func +(_ lhs: UncertainDouble, _ rhs: UncertainDouble) -> UncertainDouble {
    return UncertainDouble(value: lhs.value + rhs.value, error: pow(pow(lhs.error, 2) + pow(rhs.error, 2), 0.5))
  }

  public static func +(_ lhs: UncertainDouble, _ rhs: Double) -> UncertainDouble {
    return UncertainDouble(value: lhs.value + rhs, error: lhs.error)
  }

  public static func -(_ lhs: UncertainDouble, _ rhs: UncertainDouble) -> UncertainDouble {
    return UncertainDouble(value: lhs.value - rhs.value, error: pow(pow(lhs.error, 2) + pow(rhs.error, 2), 0.5))
  }

  public static func -(_ lhs: UncertainDouble, _ rhs: Double) -> UncertainDouble {
    return UncertainDouble(value: lhs.value - rhs, error: lhs.error)
  }

  public static func *(_ lhs: UncertainDouble, _ rhs: UncertainDouble) -> UncertainDouble {
    let val = lhs.value * rhs.value

    return UncertainDouble(
      value: val,
      error: pow(pow(val, 2) * (pow(lhs.error / lhs.value, 2) + pow(rhs.error / rhs.value, 2)), 0.5)
    )
  }

  public static func *(_ lhs: UncertainDouble, _ rhs: Double) -> UncertainDouble {
    return UncertainDouble(value: lhs.value * rhs, error: abs(lhs.error * rhs))
  }

  public static func /(_ lhs: UncertainDouble, _ rhs: UncertainDouble) -> UncertainDouble {
    let val = lhs.value / rhs.value

    return UncertainDouble(
      value: val,
      error: pow(val, 2) * (pow(lhs.error / lhs.value, 2) + pow(rhs.error / rhs.value, 2))
    )
  }

  public static func /(_ lhs: UncertainDouble, _ rhs: Double) -> UncertainDouble {
    return UncertainDouble(value: lhs.value / rhs, error: abs(lhs.error * rhs))
  }

  public static func **(_ lhs: UncertainDouble, _ power: Double) -> UncertainDouble {
    let val = pow(lhs.value, power)

    return UncertainDouble(value: val, error: abs((val * power) * (lhs.error / lhs.value)))
  }
}

extension UncertainDouble: CustomStringConvertible {
  public var description: String { "\(value) ± \(error)" }
}
