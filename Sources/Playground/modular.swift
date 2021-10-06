//
// Created by Erik Little on 10/6/21.
//

import Foundation

public protocol Ring {
  associatedtype RingType: Numeric

  var one: Self { get }

  static func +(_ lhs: Self, _ rhs: Self) -> Self
  static func *(_ lhs: Self, _ rhs: Self) -> Self
  static func **(_ lhs: Self, _ rhs: Int) -> Self
}

extension Ring  {
  public static func **(_ lhs: Self, _ rhs: Int) -> Self {
    var ret = lhs.one

    for _ in stride(from: rhs, to: 0, by: -1) {
      ret = ret * lhs
    }

    return ret
  }
}

public struct ModInt: Ring {
  public typealias RingType = Int

  public var value: Int
  public var modulo: Int

  public var one: ModInt { ModInt(1, modulo: modulo) }

  public init(_ value: Int, modulo: Int) {
    self.value = value
    self.modulo = modulo
  }

  public static func +(lhs: ModInt, rhs: ModInt) -> ModInt {
    precondition(lhs.modulo == rhs.modulo)

    return ModInt((lhs.value + rhs.value) % lhs.modulo, modulo: lhs.modulo)
  }

  public static func *(lhs: ModInt, rhs: ModInt) -> ModInt {
    precondition(lhs.modulo == rhs.modulo)

    return ModInt((lhs.value * rhs.value) % lhs.modulo, modulo: lhs.modulo)
  }
}
