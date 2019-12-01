//
// Created by Erik Little on 12/1/19.
//

import Foundation

extension BinaryInteger {
  @inlinable
  public var isZumkeller: Bool {
    let divs = factors(sorted: false)
    let sum = divs.reduce(0, +)

    guard sum & 1 != 1 else {
      return false
    }

    guard self & 1 != 1 else {
      let abundance = sum - 2*self

      return abundance > 0 && abundance & 1 == 0
    }

    return isPartSum(divs: divs[...], sum: sum / 2)
  }
}

@usableFromInline
func isPartSum<T: BinaryInteger>(divs: ArraySlice<T>, sum: T) -> Bool {
  guard sum != 0 else {
    return true
  }

  guard !divs.isEmpty else {
    return false
  }

  let last = divs.last!

  if last > sum {
    return isPartSum(divs: divs.dropLast(), sum: sum)
  }

  return isPartSum(divs: divs.dropLast(), sum: sum) || isPartSum(divs: divs.dropLast(), sum: sum - last)
}

