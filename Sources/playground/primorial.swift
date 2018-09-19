//
// Created by Erik Little on 9/18/18.
//

import BigInt
import Foundation

private let primes = Array(Eratosthenes(upTo: 100_000_000))

public func primorial(n: Int) -> BigUInt {
  return primes.lazy.prefix(n).reduce(BigUInt(1), { $0 * BigUInt($1) })
}

public func esCheck(sieve: [Int], n: Int) -> Bool {
  if n != 2 && n % 2 == 0 || n < 2 {
    return false
  } else {
    return sieve[n >> 6] & (1 << (n >> 1 & 31)) == 0
  }
}

public func esSieve(n: Int) -> (sieve: [Int], sizeSieve: Int) {
  let size = Int(Double(n) * log(Double(n)) + Double(n) * (log(log(Double(n))) - 0.9385) + 1)
  var sieve = [Int](repeating: 0, count: (size >> 6) + 1)

  for i in stride(from: 3, to: Int(Double(size).squareRoot()), by: 2) where sieve[i >> 6] & (1 << (i >> 1 & 31)) == 0 {
    for j in stride(from: i * i, to: size, by: i << 1) {
      sieve[j >> 6] |= 1 << (j >> 1 & 31)
    }
  }

  return (sieve, size)
}
