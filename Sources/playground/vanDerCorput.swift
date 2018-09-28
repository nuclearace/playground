//
// Created by Erik Little on 2018-09-28.
//

public func vanDerCorput(n: Int, base: Int, num: inout Int, denom: inout Int) {
  var n = n, p = 0, q = 1

  while n != 0 {
    p = p * base + (n % base)
    q *= base
    n /= base
  }

  num = p
  denom = q

  while p != 0 {
    n = p
    p = q % p
    q = n
  }

  num /= q
  denom /= q
}
