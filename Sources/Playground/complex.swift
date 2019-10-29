//
// Created by Erik Little on 2019-07-30.
//

import Foundation

public struct Complex {
  public var real: Double
  public var imaginary: Double

  public init(real: Double, imaginary: Double) {
    self.real = real
    self.imaginary = imaginary
  }

  public static prefix func - (rhs: Complex) -> Complex {
    return Complex(real: -rhs.real, imaginary: -rhs.imaginary)
  }

  public static func - (lhs: Complex, rhs: Complex) -> Complex {
    return lhs + (-rhs)
  }

  public static func + (lhs: Complex, rhs: Complex) -> Complex {
    return Complex(
      real: lhs.real + rhs.real,
      imaginary: lhs.imaginary + rhs.imaginary
    )
  }

  public static func * (lhs: Complex, rhs: Complex) -> Complex {
    return Complex(
      real: lhs.real * rhs.real - lhs.imaginary * rhs.imaginary,
      imaginary: lhs.real * rhs.imaginary + lhs.imaginary * rhs.real
    )
  }

  public static func / (lhs: Complex, rhs: Complex) -> Complex {
    return lhs * rhs.inverse()
  }

  public func inverse() -> Complex {
    let denom = real * real + imaginary * imaginary

    return Complex(real: real / denom, imaginary: -imaginary / denom)
  }
}

extension Complex {
  public init(real: Int = 0, imaginary: Int = 0) {
    self.real = Double(real)
    self.imaginary = Double(imaginary)
  }
}

extension Complex: CustomStringConvertible {
  public var description: String {
    let real2 = real != -0 ? real : 0.0
    let imag = imaginary != -0 ? imaginary : 0.0

    let result =
      (imag >= 0 ? "\(real2) + \(imag)i" : "\(real2) - \(-imag)i")
        .replacingOccurrences(of: ".0 ", with: " ")
        .replacingOccurrences(of: ".0i", with: "i")
        .replacingOccurrences(of: " + 0i", with: "")

    if result.hasPrefix("0 ") {
      return result
        .replacingOccurrences(of: "0 ", with: "")
        .replacingOccurrences(of: " ", with: "")
    } else {
      return result
    }
  }
}
