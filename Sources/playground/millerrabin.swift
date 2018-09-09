//
// Created by Erik Little on 9/9/18.
//

import BigInt

// Miller-Rabin prime test
func isPrime(_ n: BigInt, rounds: Int = 5) -> Bool {
  guard n != 2 else { return true }
  guard n % 2 != 0 && n > 2 else { return false }

  var s = 0
  var d = n - 1

  while true {
    let (quo, rem) = (d / 2, d % 2)

    guard rem != 1 else { break }

    s += 1
    d = quo
  }

  func tryComposite(_ a: BigInt) -> Bool {
    guard a.power(d, modulus: n) != 1 else { return false }

    for i in 0..<s where a.power((2 as BigInt).power(i) * d, modulus: n) == n - 1 {
      return false
    }

    return true
  }

  for _ in 0..<rounds where tryComposite(BigInt(BigUInt.randomInteger(lessThan: BigUInt(n)))) {
    return false
  }

  return true
}
