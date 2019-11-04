//
// Created by Erik Little on 11/4/19.
//

import Foundation

@inlinable
public func bernoulli<T: BinaryInteger & SignedNumeric>(n: Int) -> Frac<T> {
  guard n != 0 else {
    return 1
  }

  var arr = [Frac<T>]()

  for m in 0...n {
    arr.append(Frac(numerator: 1, denominator: T(m) + 1))

    for j in stride(from: m, through: 1, by: -1) {
      arr[j-1] = (arr[j-1] - arr[j]) * Frac(numerator: T(j), denominator: 1)
    }
  }

  return arr[0]
}
