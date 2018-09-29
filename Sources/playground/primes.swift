//
// Created by Erik Little on 9/9/18.
//

import BigInt

public func largestLeftTruncatablePrime(_ base: Int) -> BigInt {
  var radix = 0
  var candidates = [BigInt(0)]

  while true {
    let multiplier = BigInt(base).power(radix)
    var newCandidates = [BigInt]()

    for i in 1..<BigInt(base) {
      newCandidates += candidates.map({ ($0+i*multiplier, ($0+i*multiplier).isPrime(rounds: 30)) })
                                 .filter({ $0.1 })
                                 .map({ $0.0 })
    }

    if newCandidates.count == 0 {
      return candidates.max()!
    }

    candidates = newCandidates
    radix += 1
  }
}

// Miller-Rabin prime test
public func isPrime(_ n: BigInt, rounds: Int = 5) -> Bool {
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

extension BinaryInteger {
  @inlinable
  public func primeDecomposition() -> [Self] {
    // Use free generic function for aggressive specialization
    return Playground.primeDecomposition(of: self)
  }
}

// Force generic function to be the body of the instance method
@usableFromInline @inline(__always)
func primeDecomposition<T: BinaryInteger>(of n: T) -> [T] {
  guard n > 2 else { return [] }

  func step(_ x: T) -> T {
    return 1 + (x << 2) - ((x >> 1) << 1)
  }

  let maxQ = Int(Double(n).squareRoot())
  var d: T = 1
  var q: T = n % 2 == 0 ? 2 : 3

  while q <= maxQ && n % q != 0 {
    q = step(d)
    d += 1
  }

  return q <= maxQ ? [q] + primeDecomposition(of: n / q) : [n]
}

// Swift doesn't do a great job of tail call optimization, so this blows up with big numbers
public func primeDecompositionRec(of n: Int) -> [Int] {
  func factors(n: Int, k: Int, acc: [Int], sqr: Int) -> [Int] {
    switch (n, k, acc, sqr) {
    case (1, _, acc, _):
      return acc
    case (n, k, acc, _) where n % k == 0:
      return factors(n: n / k, k: k, acc: acc + [k], sqr: Int(Double(n / k).squareRoot()))
    case (n, k, acc, sqr) where k < sqr:
      return factors(n: n, k: k + 1, acc: acc, sqr: sqr)
    case (n, k, acc, sqr) where k >= sqr:
      return factors(n: 1, k: k, acc: acc + [n], sqr: 0)
    case _:
      fatalError()
    }
  }

  return factors(n: n, k: 2, acc: [], sqr: Int(Double(n).squareRoot()))
}
