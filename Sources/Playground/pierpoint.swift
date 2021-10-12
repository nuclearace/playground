//
// Created by Erik Little on 1/24/20.
//

import BigInt
import Foundation

func fmtBig(_ n: BigInt) -> String {
  let asString = String(n)
  let leftOver = asString.count - 100

  return "\(String(asString.prefix(100)))" + (leftOver > 0 ? "... \(leftOver) digits" : "")
}

public func pierpoint(n: Int) -> (first: [BigInt], second: [BigInt]) {
  var primes = (first: [BigInt](repeating: 0, count: n), second: [BigInt](repeating: 0, count: n))

  primes.first[0] = 2

  var count1 = 1, count2 = 0
  var s = [BigInt(1)]
  var i2 = 0, i3 = 0, k = 1
  var n2 = BigInt(0), n3 = BigInt(0), t = BigInt(0)

  while min(count1, count2) < n {
    n2 = s[i2] * 2
    n3 = s[i3] * 3

    if n2 < n3 {
      t = n2
      i2 += 1
    } else {
      t = n3
      i3 += 1
    }

    if t <= s[k - 1] {
      continue
    }

    s.append(t)
    k += 1
    t += 1

    if count1 < n && t.isPrime(rounds: 10) {
      // print("Found 1st order: \(fmtBig(t)); \(count1)")
      primes.first[count1] = t
      count1 += 1
    }

    t -= 2

    if count2 < n && t.isPrime(rounds: 10) {
      // print("Found 2nd order: \(fmtBig(t)); \(count2)")
      primes.second[count2] = t
      count2 += 1
    }
  }

  return primes
}
