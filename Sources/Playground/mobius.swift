//
// Created by Erik Little on 10/3/19.
//

import Foundation

public enum MobiusResult: CustomStringConvertible {
  case neg
  case zero
  case pos

  public var description: String {
    switch self {
    case .neg:
      return "-1"
    case .zero:
      return "0"
    case .pos:
      return "1"
    }
  }
}

extension BinaryInteger {
  @inlinable
  public func möbius() -> MobiusResult {
    let factorization = primeDecomposition()

    guard Set(factorization).count == factorization.count else {
      return .zero
    }

    return factorization.count & 1 == 1 ? .neg : .pos
  }
}
