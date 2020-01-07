//
// Created by Erik Little on 1/7/20.
//

import BigInt
import Foundation

@inlinable
public func fermatNumbers<T: BinaryInteger>(n: T) -> [T] {
  var f = T(3)
  var res = [T]()

  for _ in stride(from: 0, to: n, by: 1) {
    res.append(f)
    f -= 1
    f *= f
    f += 1
  }

  return res
}
