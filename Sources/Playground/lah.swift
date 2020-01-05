//
// Created by Erik Little on 1/5/20.
//

import Foundation

@inlinable
public func lah<T: BinaryInteger>(n: T, k: T) -> T {
  if k == 1 {
    return factorial(n)
  } else if k == n {
    return 1
  } else if k > n {
    return 0
  } else if k < 1 || n < 1 {
    return 0
  } else {
    let a = (factorial(n) * factorial(n - 1))
    let b = (factorial(k) * factorial(k - 1))
    let c = factorial(n - k)

    return a / b / c
  }
}
