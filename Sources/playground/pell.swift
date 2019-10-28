//
// Created by Erik Little on 10/28/19.
//

import Foundation

@inlinable
public func solvePell<T: BinaryInteger>(n: T, _ a: inout T, _ b: inout T) {
  func swap(_ a: inout T, _ b: inout T, mul by: T) {
    (a, b) = (b, b * by + a)
  }

  let x = T(Double(n).squareRoot())
  var y = x
  var z = T(1)
  var r = x << 1
  var e1 = T(1)
  var e2 = T(0)
  var f1 = T(0)
  var f2 = T(1)

  while true {
    y = r * z - y
    z = (n - y * y) / z
    r = (x + y) / z

    swap(&e1, &e2, mul: r)
    swap(&f1, &f2, mul: r)

    (a, b) = (f2, e2)

    swap(&b, &a, mul: x)

    if a * a - n * b * b == 1 {
      return
    }
  }
}
