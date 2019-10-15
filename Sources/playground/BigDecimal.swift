//
// Created by Erik Little on 10/15/19.
//

import BigInt

public struct BigDecimal {
  var figure = 0
  var internalInteger: BigInt

  public init?(_ string: String) {
    if let range = string.range(of: ".") {
      figure = Int(string[range.lowerBound..<string.index(before: string.endIndex)].count)

      guard let int = BigInt(string.replacingCharacters(in: range, with: "")) else {
        return nil
      }

      internalInteger = int
    } else {
      guard let int = BigInt(string) else {
        return nil
      }

      internalInteger = int
    }
  }

  public init(bigInteger: BigInt, figure: Int) {
    internalInteger = bigInteger
    self.figure = Int(figure)
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

    if figure == 0 {
      return string
    } else {
      var newFigure = string.count - Int(figure)

      while newFigure <= 0 {
        string.insert("0", at: string.startIndex)
        newFigure += 1
      }

      string.insert(".", at: string.index(string.startIndex, offsetBy: newFigure))

      return string
    }
  }
}

public extension BigDecimal {
  func add(_ rhs: BigDecimal) -> BigDecimal {
    var maxFigure = 0
    var workingInt = internalInteger
    var rhsFigure = rhs.figure
    var rhsInt = rhs.internalInteger

    if figure >= rhs.figure {
      maxFigure = figure
      rhsInt *= BigInt(10).power(maxFigure - rhs.figure)
      rhsFigure = maxFigure
    } else {
      maxFigure = rhsFigure
      workingInt *= BigInt(10).power(maxFigure - figure)
    }

    let newInteger = workingInt + rhsInt
    let newDecimal = BigDecimal(bigInteger: newInteger, figure: maxFigure)

    return newDecimal
  }

  func divide(_ rhs: BigDecimal) -> BigDecimal {
    var totalFigure = figure - rhs.figure
    var workingInt = internalInteger

    if totalFigure < 0 {
      let exponent = -totalFigure
      totalFigure = 0

      workingInt *= BigInt(10).power(exponent)
    }

    let newInteger = workingInt / rhs.internalInteger
    let newDecimal = BigDecimal(bigInteger: newInteger, figure: totalFigure)

    return newDecimal
  }

  func multiply(_ rhs: BigDecimal) -> BigDecimal {
    let totalFigure = figure + rhs.figure
    let newInteger = internalInteger * rhs.internalInteger
    let newDecimal = BigDecimal(bigInteger: newInteger, figure: totalFigure)

    return newDecimal
  }

  func subtract(_ rhs: BigDecimal) -> BigDecimal {
    var maxFigure = 0
    var workingInt = internalInteger
    var rhsFigure = rhs.figure
    var rhsInt = rhs.internalInteger

    if figure >= rhs.figure {
      maxFigure = figure
      rhsInt *= BigInt(10).power(maxFigure - rhs.figure)
      rhsFigure = maxFigure
    } else {
      maxFigure = rhsFigure
      workingInt *= BigInt(10).power(maxFigure - figure)
    }

    let newInteger = workingInt - rhsInt
    let newDecimal = BigDecimal(bigInteger: newInteger, figure: Int(maxFigure))

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
