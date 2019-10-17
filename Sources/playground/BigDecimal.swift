//
// Created by Erik Little on 10/15/19.
//

import BigInt
import Foundation

public struct BigDecimal {
  public private(set) var scale = 0
  public private(set) var precision = 0

  fileprivate var internalInteger: BigInt

  public init?(_ string: String) {
    guard !string.isEmpty else {
      return nil
    }

    if let range = string.range(of: ".") {
      scale = Int(string[range.lowerBound..<string.index(before: string.endIndex)].count)

      guard let int = BigInt(string.replacingCharacters(in: range, with: "")) else {
        return nil
      }

      internalInteger = int
      precision = internalInteger.description.dropFirstIf("-").count
    } else {
      guard let int = BigInt(string) else {
        return nil
      }

      internalInteger = int
      precision = internalInteger.description.dropFirstIf("-").count
    }
  }

  public init(bigInteger: BigInt, scale: Int) {
    internalInteger = bigInteger
    self.scale = scale
    self.precision = internalInteger.description.count
  }

  public init(_ int: Int) {
    self.init(String(int))!
  }

  public init(_ double: Double) {
    self.init(String(double))!
  }
}

extension BigDecimal: CustomStringConvertible {
  public var description: String { stringValue }

  public var stringValue: String {
    var string = internalInteger.description

    if scale == 0 {
      return string
    } else {
      var newScale = string.count - Int(scale)

      while newScale <= 0 {
        string.insert("0", at: string.startIndex)
        newScale += 1
      }

      string.insert(".", at: string.index(string.startIndex, offsetBy: newScale))

      return string
    }
  }
}

public extension BigDecimal {
  func add(_ rhs: BigDecimal) -> BigDecimal {
    var maxScale = 0
    var workingInt = internalInteger
    var rhsScale = rhs.scale
    var rhsInt = rhs.internalInteger

    if scale >= rhs.scale {
      maxScale = scale
      rhsInt *= BigInt(10).power(maxScale - rhs.scale)
      rhsScale = maxScale
    } else {
      maxScale = rhsScale
      workingInt *= BigInt(10).power(maxScale - scale)
    }

    let newInteger = workingInt + rhsInt
    let newDecimal = BigDecimal(bigInteger: newInteger, scale: maxScale)

    return newDecimal
  }

  func divide(_ rhs: BigDecimal) -> BigDecimal {
    guard rhs.internalInteger != 0 else {
      fatalError()
    }

    guard internalInteger != 0 else {
      return BigDecimal(1)
    }

    let dividend = self
    let divisor = rhs
    // todo: rounding and different precision
    let desiredPrecision = dividend.precision//min(precision + Int(ceil(10.0 * Double(divisor.precision) / 3.0)), .max)
    let desiredScale = scale - divisor.scale
    let xScale = dividend.precision
    var yScale = divisor.precision

    if dividend.internalInteger.magnitude > divisor.internalInteger.magnitude {
      yScale -= 1
    }

    let power = desiredPrecision + yScale - xScale
    let scl = desiredScale + yScale - xScale + desiredPrecision

    if power > 0 {
      let raised = dividend.internalInteger * BigInt(10).power(power)
      let newInteger = raised / divisor.internalInteger

      return BigDecimal(bigInteger: newInteger, scale: scl)
    } else {
        let newInteger = dividend.internalInteger / divisor.internalInteger

        return BigDecimal(bigInteger: newInteger, scale: scl)
    }
  }

  func multiply(_ rhs: BigDecimal) -> BigDecimal {
    let totalScale = scale + rhs.scale
    let newInteger = internalInteger * rhs.internalInteger
    let newDecimal = BigDecimal(bigInteger: newInteger, scale: totalScale)

    return newDecimal
  }

  func subtract(_ rhs: BigDecimal) -> BigDecimal {
    var maxScale = 0
    var workingInt = internalInteger
    var rhsScale = rhs.scale
    var rhsInt = rhs.internalInteger

    if scale >= rhs.scale {
      maxScale = scale
      rhsInt *= BigInt(10).power(maxScale - rhs.scale)
      rhsScale = maxScale
    } else {
      maxScale = rhsScale
      workingInt *= BigInt(10).power(maxScale - scale)
    }

    let newInteger = workingInt - rhsInt
    let newDecimal = BigDecimal(bigInteger: newInteger, scale: Int(maxScale))

    return newDecimal
  }
}

public extension BigDecimal {
  func add(_ rhs: Int) -> BigDecimal {
    return add(BigDecimal(rhs))
  }

  func divide(_ rhs: Int) -> BigDecimal {
    return divide(BigDecimal(rhs))
  }

  func multiply(_ rhs: Int) -> BigDecimal {
    return multiply(BigDecimal(rhs))
  }

  func subtract(_ rhs: Int) -> BigDecimal {
    return subtract(BigDecimal(rhs))
  }
}

public extension BigDecimal {
  func add(_ rhs: Double) -> BigDecimal {
    return add(BigDecimal(rhs))
  }

  func divide(_ rhs: Double) -> BigDecimal {
    return divide(BigDecimal(rhs))
  }

  func multiply(_ rhs: Double) -> BigDecimal {
    return multiply(BigDecimal(rhs))
  }

  func subtract(_ rhs: Double) -> BigDecimal {
    return subtract(BigDecimal(rhs))
  }
}

public extension BigDecimal {
  static func +(lhs: BigDecimal, rhs: BigDecimal) -> BigDecimal {
    return lhs.add(rhs)
  }

  static func -(lhs: BigDecimal, rhs: BigDecimal) -> BigDecimal {
    return lhs.subtract(rhs)
  }

  static func /(lhs: BigDecimal, rhs: BigDecimal) -> BigDecimal {
    return lhs.divide(rhs)
  }

  static func *(lhs: BigDecimal, rhs: BigDecimal) -> BigDecimal {
    return lhs.multiply(rhs)
  }

  static func +(lhs: BigDecimal, rhs: Int) -> BigDecimal {
    return lhs.add(rhs)
  }

  static func -(lhs: BigDecimal, rhs: Int) -> BigDecimal {
    return lhs.subtract(rhs)
  }

  static func /(lhs: BigDecimal, rhs: Int) -> BigDecimal {
    return lhs.divide(rhs)
  }

  static func *(lhs: BigDecimal, rhs: Int) -> BigDecimal {
    return lhs.multiply(rhs)
  }

  static func +(lhs: BigDecimal, rhs: Double) -> BigDecimal {
    return lhs.add(rhs)
  }

  static func -(lhs: BigDecimal, rhs: Double) -> BigDecimal {
    return lhs.subtract(rhs)
  }

  static func /(lhs: BigDecimal, rhs: Double) -> BigDecimal {
    return lhs.divide(rhs)
  }

  static func *(lhs: BigDecimal, rhs: Double) -> BigDecimal {
    return lhs.multiply(rhs)
  }
}

extension BigDecimal: Equatable {

}
