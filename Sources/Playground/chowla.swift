//
// Created by Erik Little on 11/5/19.
//

import Foundation

@inlinable
public func chowla<T: BinaryInteger>(n: T) -> T {
  stride(from: 2, to: T(Double(n).squareRoot()+1), by: 1)
    .lazy
    .filter({ n % $0 == 0 })
    .reduce(0, {(s: T, m: T) -> T in
      m*m == n ? s + m : s + m + (n / m)
    })
}
