//
// Created by Erik Little on 10/24/19.
//

import BigInt

public struct DigitsOfPi: Sequence, IteratorProtocol {
  private var r = BigInt(0)
  private var q = BigInt(1), t = BigInt(1), k = BigInt(1)
  private var n = BigInt(3), l = BigInt(3)
  private var nr = BigInt(0), nn = BigInt(0)

  public init() {}

  public mutating func next() -> Int? {
    while 4 * q + r - t >= n * t {
      nr = (2 * q + r) * l
      nn = (q * (7 * k) + 2 + (r * l)) / (t * l)
      q = q * k
      t = t * l
      l = l + 2
      k = k + 1
      n = nn
      r = nr
    }

    let ret = n

    nr = 10 * (r - n * t)
    n  = ((10 * (3 * q + r)) / t) - (10 * n)
    q  = q * 10
    r  = nr

    return Int(ret)
  }
}
