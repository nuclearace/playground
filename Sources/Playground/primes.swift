//
// Created by Erik Little on 9/9/18.
//

import BigInt
import Foundation

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

extension BinaryInteger {
  @inlinable
  public var isAttractive: Bool {
    return primeDecomposition().count.isPrime
  }

  @inlinable
  public var isPrime: Bool {
    if self == 0 || self == 1 {
      return false
    } else if self == 2 {
      return true
    }

    let max = Self(ceil((Double(self).squareRoot())))

    for i in stride(from: 2, through: max, by: 1) where self % i == 0  {
      return false
    }

    return true
  }

  // Miller-Rabin prime test
  @inlinable
  public func isProbablyPrime(rounds: Int = 10, powerOf2Cache: [Int: Self]? = nil) -> Bool {
    guard self > 1 else { return false }
    guard self != 2 && self != 3 else { return true }
    guard self % 2 != 0 else { return false }

    let smolPrimes: [Self] = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43]

    for prime in smolPrimes {
      if prime == self {
        return true
      } else if self % prime == 0 {
        return false
      }
    }

    var s = 0
    var d = self - 1
    var powerCache = powerOf2Cache ?? [Int: Self]()

    while true {
      let (quo, rem) = d.quotientAndRemainder(dividingBy: 2)

      guard rem != 1 else { break }

      s += 1
      d = quo
    }

    func tryComposite(_ a: Self) -> Bool {
      guard a.modPow(exp: d, mod: self) != 1 else {
        return false
      }

      for i in 0..<s {
        if powerCache[i] == nil {
          powerCache[i] = Self(2).power(Self(i))
        }

        guard !(a.modPow(exp: powerCache[i]! * d, mod: self) == self - 1) else {
          return false
        }
      }

      return true
    }

    for _ in 0..<rounds where tryComposite(Self.randomInt(lessThan: self - 2) + 2) {
      return false
    }

    return true
  }

  @inlinable
  public func primeDecomposition() -> [Self] {
    guard self > 1 else { return [] }

    func step(_ x: Self) -> Self {
      return 1 + (x << 2) - ((x >> 1) << 1)
    }

    let maxQ = Self(Double(self).squareRoot())
    var d: Self = 1
    var q: Self = self & 1 == 0 ? 2 : 3

    while q <= maxQ && self % q != 0 {
      q = step(d)
      d += 1
    }

    return q <= maxQ ? [q] + (self / q).primeDecomposition() : [self]
  }

  @inlinable
  public func isSmooth(n: Self, primes: [Self]? = nil) -> Bool {
    guard self != 1, self >= n else {
      return true
    }

    guard n != 9 else {
      return false
    }

    var work = self
    var factors = [Self]()

    for p in primes ?? stride(from: 2, to: n + 1, by: 1).filter({ $0.isPrime }) {
      while work % p == 0 {
        factors.append(p)

        work /= p
      }
    }

    guard !factors.isEmpty else {
      return false
    }

    return factors.reduce(1, *) == self
  }
}

public func lucasLehmer(_ p: Int) -> Bool {
  let m = BigInt(2).power(p) - 1
  var s = BigInt(4)

  for _ in 0..<p-2 {
    s = ((s * s) - 2) % m
  }

  return s == 0
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

@usableFromInline
func smallPrimes(num: Int) -> [Int] {
  var primes = [2]

  var i = 3

  while primes.count != num {
    if i.isPrime {
      primes.append(i)
    }

    i += 2
  }

  return primes
}

@usableFromInline
func polyMult<T: BinaryInteger>(a: [T], b: [T], r: T, p: T) -> [T] {
  var res: [T] = Array(repeating: 0, count: Int(r))

  for (i, u) in a.enumerated() {
    for (j, v) in b.enumerated() {
      let idx = Int(T(i + j) % r)

      res[idx] = (res[idx] + u * v ) % p
    }
  }

  return res
}

extension BinaryInteger {
  @usableFromInline
  func testPoly(p: Self, r: Self) -> Bool {
    var ans: [Self] = [1]
    var poly = [self, 1]
    var n = p

    while n != 0 {
      if n & 1 == 1 {
        ans = polyMult(a: ans, b: poly, r: r, p: p)
      }

      n >>= 1
      poly = polyMult(a: poly, b: poly, r: r, p: p)
    }

    var check: [Self] = Array(repeating: 0, count: Int(r))

    (check[0], check[Int(p % r)]) = (self, 1)

    return ans == check
  }
}

@inlinable
public func aksPrimeTest<T: BinaryInteger & SignedNumeric>(n: T) -> Bool {
  guard n != 0 || n != 1 else {
    return false
  }

  guard n != 2 else {
    return true
  }

  guard !n.isPerfectPower() else {
    return false
  }

  let log2n = log2(Double(n))
  let log2n2 = T(log2n).power(2)
  var r = log2n2 + 1

  rSearch: while true {
    defer {
      r += 1
    }

    guard n.gcd(with: r) == 1 else {
      continue
    }

    var ans: T = 1

    for k in stride(from: 1, to: r, by: 1) {
      ans = ans * n % r

      if ans == 1 {
        if k > log2n2 {
          break rSearch
        } else {
          break
        }
      }
    }
  }

  for a in stride(from: 2, through: min(r, n - 1), by: 1) where n % a == 0 {
    return false
  }

  if n <= r {
    return true
  }

  let totR = Double(totient(n: r)).squareRoot()
  let maxA = totR * log2n

  for a in stride(from: 1, through: T(floor(maxA)), by: 1) where !a.testPoly(p: n, r: r) {
    return false
  }

  return true
}

@inlinable
public func carmichael<T: BinaryInteger & SignedNumeric>(p1: T) -> [(T, T, T)] {
  func mod(_ n: T, _ m: T) -> T { (n % m + m) % m }

  var res = [(T, T, T)]()

  guard p1.isPrime else {
    return res
  }

  for h3 in stride(from: 2, to: p1, by: 1) {
    for d in stride(from: 1, to: h3 + p1, by: 1) {
      if (h3 + p1) * (p1 - 1) % d != 0 || mod(-p1 * p1, h3) != d % h3 {
        continue
      }

      let p2 = 1 + (p1 - 1) * (h3 + p1) / d

      guard p2.isPrime else {
        continue
      }

      let p3 = 1 + p1 * p2 / h3

      guard p3.isPrime && (p2 * p3) % (p1 - 1) == 1 else {
        continue
      }

      res.append((p1, p2, p3))
    }
  }

  return res
}

@inlinable
public func smoothN<T: BinaryInteger>(n: T, count: Int) -> [T] {
  let primes = stride(from: 2, to: n + 1, by: 1).filter({ $0.isPrime })
  var next = primes
  var indices = [Int](repeating: 0, count: primes.count)
  var res = [T](repeating: 0, count: count)

  res[0] = 1

  guard count > 1 else {
    return res
  }

  for m in 1..<count {
    res[m] = next.min()!

    for i in 0..<indices.count where res[m] == next[i] {
      indices[i] += 1
      next[i] = primes[i] * res[indices[i]]
    }
  }

  return res
}

public struct KPrimeGen: Sequence, IteratorProtocol {
  private let k: Int
  private var n: Int

  public init(k: Int, n: Int) {
    self.k = k
    self.n = n
  }

  private func isKPrime() -> Bool {
    var primes = 0
    var f = 2
    var rem = n

    while primes < k && rem > 1 {
      while rem % f == 0 && rem > 1 {
        rem /= f
        primes += 1
      }

      f += 1
    }

    return rem == 1 && primes == k
  }

  public mutating func next() -> Int? {
    n += 1

    while !isKPrime() {
      n += 1
    }

    return n
  }
}

@inlinable
public func isEmirp<T: BinaryInteger>(n: T) -> Bool {
  guard n.isPrime else {
    return false
  }

  var aux = n
  var revPrime = T(0)

  while aux > 0 {
    revPrime = revPrime * 10 + aux % 10
    aux /= 10
  }

  guard n != revPrime else {
    return false
  }

  return revPrime.isPrime
}

public func φ(_ x: Int, _ a: Int) -> Int {
  struct Cache {
    static let primes = eratosthenes(limit: 1_000_000_000)
    static var cache = [String: Int]()
  }

  guard a != 0 else {
    return x
  }

  guard Cache.cache["\(x),\(a)"] == nil else {
    return Cache.cache["\(x),\(a)"]!
  }

  Cache.cache["\(x),\(a)"] = φ(x, a - 1) - φ(x / Cache.primes[a - 1], a - 1)

  return Cache.cache["\(x),\(a)"]!
}

public func π(n: Int) -> Int {
  guard n > 2 else {
    return 0
  }

  let a = π(n: Int(Double(n).squareRoot()))

  return φ(n, a) + a - 1
}

@inlinable
public func isWilsonPrime<T: BinaryInteger>(_ n: T) -> Bool {
  guard n >= 2 else {
    return false
  }

  return (factorial(n - 1) + 1) % n == 0
}
