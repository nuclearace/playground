//
// Created by Erik Little on 2019-08-01.
//

import BigInt
import Foundation

extension Numeric where Self: Strideable {
  @inlinable
  public func power(_ n: Self) -> Self {
    return stride(from: 0, to: n, by: 1).lazy.map({_ in self }).reduce(1, *)
  }
}

extension BinaryInteger {
  @inlinable
  public var highestSetBit: Self {
    guard let hi = highestSetBitPosition else {
      return 0
    }

    return 1 << hi
  }

  @inlinable
  public var highestSetBitPosition: Int? {
    guard self != 0 else {
      return nil
    }

    for i in stride(from: bitWidth - 1, through: 0, by: -1) where self & 1 << i != 0 {
      return i
    }

    fatalError()
  }

  @inlinable
  public var isNarcissistic: Bool {
    let digits = String(self).map({ Int(String($0))! })
    let m = digits.count

    guard m != 1 else {
      return true
    }

    return digits.map({ $0.power(m) }).reduce(0, +) == self
  }

  @inlinable
  public var isSmith: Bool {
    guard self > 3 else {
      return false
    }

    let primeFactors = primeDecomposition()

    guard primeFactors.count != 1 else {
      return false
    }

    return primeFactors.map({ $0.sumDigits() }).reduce(0, +) == sumDigits()
  }

  @inlinable
  public var isSquare: Bool {
    var x = self / 2
    var seen = Set([x])

    while x * x != self {
      x = (x + (self / x)) / 2

      if seen.contains(x) {
        return false
      }

      seen.insert(x)
    }

    return true
  }

  @inlinable
  public var isSelfDescribing: Bool {
    let asString = String(self)
    let counts = asString.reduce(into: [Int: Int](), {res, char in res[Int(String(char)), default: 0] += 1})

    for (i, n) in asString.enumerated() where counts[i, default: 0] != Int(String(n)) {
      return false
    }

    return true
  }

  @inlinable
  public func egyptianDivide(by divisor: Self) -> (quo: Self, rem: Self) {
    let table =
      (0...).lazy
        .map({i -> (Self, Self) in
          let power = Self(2).power(Self(i))

          return (power, power * divisor)
        })
        .prefix(while: { $0.1 <= self })
        .reversed()

    let (answer, acc) = table.reduce((Self(0), Self(0)), {cur, row in
      let ((ans, acc), (power, doubling)) = (cur, row)

      return acc + doubling <= self ? (ans + power, doubling + acc) : cur
    })

    return (answer, Self((acc - self).magnitude))
  }

  @inlinable
  public func factors(sorted: Bool = true) -> [Self] {
    let maxN = Self(Double(self).squareRoot())
    var res = Set<Self>()

    for factor in stride(from: 1, through: maxN, by: 1) where self % factor == 0 {
      res.insert(factor)
      res.insert(self / factor)
    }

    return sorted ? res.sorted() : Array(res)
  }

  @inlinable
  public func modPow(exp: Self, mod: Self) -> Self {
    guard exp != 0 else {
      return 1
    }

    var res = Self(1)
    var base = self % mod
    var exp = exp

    while true {
      if exp & 1 == 1 {
        res *= base
        res %= mod
      }

      if exp == 1 {
        return res
      }

      exp >>= 1
      base *= base
      base %= mod
    }
  }

  @usableFromInline
  func fastExp(_ exp: Int) -> Self {
    var ans: Self = 1
    var work = self
    var exp = exp

    while exp > 0 {
      if exp & 1 == 1 {
        ans *= work
      }

      work *= work
      exp >>= 1
    }

    return ans
  }

  @inlinable
  public func modInv(_ mod: Self) -> Self {
    var (m, n) = (mod, self)
    var (x, y) = (Self(0), Self(1))

    while n != 0 {
      (x, y) = (y, x - (m / n) * y)
      (m, n) = (n, m % n)
    }

    while x < 0 {
      x += mod
    }

    return x
  }

  @inlinable
  public func gcd(with other: Self) -> Self {
    var gcd = self
    var b = other

    while b != 0 {
      (gcd, b) = (b, gcd % b)
    }

    return gcd
  }

  @inlinable
  public func lcm(with other: Self) -> Self {
    let g = gcd(with: other)

    return self / g * other
  }

  @inlinable
  public func sumDigits() -> Self {
    return String(self).lazy.map({ Self(Int(String($0))!) }).reduce(0, +)
  }

  @inlinable
  public func countDivisors() -> Int {
    var workingN = self
    var count = 1

    while workingN & 1 == 0 {
      workingN >>= 1

      count += 1
    }

    var d = Self(3)

    while d * d <= workingN {
      var (quo, rem) = workingN.quotientAndRemainder(dividingBy: d)

      if rem == 0 {
        var dc = 0

        while rem == 0 {
          dc += count
          workingN = quo

          (quo, rem) = workingN.quotientAndRemainder(dividingBy: d)
        }

        count += dc
      }

      d += 2
    }

    return workingN != 1 ? count * 2 : count
  }
}

extension BinaryInteger where Self: SignedNumeric {
  @inlinable
  public var isPerfectNumber: Bool {
    var sum = Frac(numerator: 1, denominator: self)

    let maxN = Self(ceil(Double(self).squareRoot()))

    for factor in stride(from: 2, to: maxN, by: 1) where self % factor == 0 {
      sum += Frac(numerator: 1, denominator: factor)
      sum += Frac(numerator: 1, denominator: self / factor)
    }

    return sum == 1
  }

  @inlinable
  public func isPerfectPower() -> Bool {
    if -self & self == self {
      return true
    }

    let lgN = 1 + (String(abs(self), radix: 2).count - 2)

    if lgN <= 2 {
      return false
    }

    for b in 2..<lgN {
      var lowA: Self = 1
      var highA: Self  = 1 << Self(lgN / b + 1)

      while lowA < highA - 1 {
        let midA = (lowA + highA) >> 1
        let ab = midA.fastExp(b)

        if ab > self {
          highA = midA
        } else if ab < self {
          lowA = midA
        } else {
          return true
        }
      }
    }

    return false
  }
}

@inlinable
public func flyStraightDammit<T: BinaryInteger>(n: T) -> T {
  guard n > 1 else {
    return n
  }

  let previousN = flyStraightDammit(n: n - 1)
  let gcd = n.gcd(with: previousN)

  if gcd == 1 {
    return previousN + n + 1
  } else {
    return previousN / gcd
  }
}

@inlinable
public func flyStraightDammitIterative<T: BinaryInteger>(n: T) -> T {
  guard n > 1 else {
    return n
  }

  var previousN: T = 1
  var c: T = 2

  while c <= n {
    let gcd = c.gcd(with: previousN)

    if gcd == 1 {
      previousN += c + 1
    } else {
      previousN /= gcd
    }

    c += 1
  }

  return previousN
}

extension FixedWidthInteger {
  @inlinable
  public func wouldOverflow(adding other: Self) -> Bool {
    let summed = self &+ other

    if self > 0 && other > 0 && summed < 0 {
      return true
    } else if self < 0 && other < 0 && summed > 0 {
      return true
    } else {
      return false
    }
  }

  @inlinable
  public func wouldOverflow(multiplying other: Self) -> Bool {
    if self == 0 || other == 0 {
      return false
    }

    let res = (self &* other) / self

    return res != self && res != other
  }

  @inlinable
  public func wouldOverflow(subtracting other: Self) -> Bool {
    let subbed = self &- other

    if self > 0 && other < 0 && subbed < 0 {
      return true
    } else if self < 0 && other > 0 && subbed > 0 {
      return true
    } else {
      return false
    }
  }
}

@inlinable
public func exactlyNDivisors<TermType: BinaryInteger>(numTerms: Int) -> [TermType] {
  let primes = smallPrimes(num: numTerms)
  var seq = [TermType]()

  for i in 1...numTerms {
    if i.isPrime {
      seq.append(TermType(primes[i - 1]).power(TermType(i - 1)))
    } else {
      var count = 0
      var j = 1

      while true {
        if i & 1 == 1 {
          let sqr = Int(Double(j).squareRoot())

          if sqr * sqr != j {
            j += 1
            continue
          }
        }

        if j.countDivisors() == i {
          count += 1

          if count == i {
            seq.append(TermType(j))
            break
          }
        }

        j += 1
      }
    }
  }

  return seq
}

extension FloatingPoint where Self: ExpressibleByFloatLiteral {
  @inlinable
  public func root(n: Self, epsilon: Self = 2.220446049250313e-16) -> Self {
    guard self != 0 else {
      return 0
    }

    guard n >= 1 else {
      return .nan
    }

    var d = Self(0)
    var res = Self(1)

    repeat {
      d = (self / res.power(n - 1.0) - res) / n
      res += d
    } while d >= epsilon * 10 || d <= -epsilon * 10

    return res
  }
}

@inlinable
public func isAbundant<T: BinaryInteger>(n: T) -> (Bool, [T]) {
  let divs = n.factors().dropLast()

  return (divs.reduce(0, +) > n, Array(divs))
}

// FIXME: Remove when Numerics lib has this
extension FloatingPoint {
  @inlinable
  public func isAlmostEqual(
    to other: Self,
    tolerance: Self = Self.ulpOfOne.squareRoot()
  ) -> Bool {
    // tolerances outside of [.ulpOfOne,1) yield well-defined but useless results,
    // so this is enforced by an assert rathern than a precondition.
    assert(tolerance >= .ulpOfOne && tolerance < 1, "tolerance should be in [.ulpOfOne, 1).")
    // The simple computation below does not necessarily give sensible
    // results if one of self or other is infinite; we need to rescale
    // the computation in that case.
    guard self.isFinite && other.isFinite else {
      return rescaledAlmostEqual(to: other, tolerance: tolerance)
    }
    // This should eventually be rewritten to use a scaling facility to be
    // defined on FloatingPoint suitable for hypot and scaled sums, but the
    // following is good enough to be useful for now.
    let scale = max(abs(self), abs(other), .leastNormalMagnitude)
    return abs(self - other) < scale*tolerance
  }

  @inlinable
  public func isAlmostZero(
    absoluteTolerance tolerance: Self = Self.ulpOfOne.squareRoot()
  ) -> Bool {
    assert(tolerance > 0)
    return abs(self) < tolerance
  }

  @usableFromInline
  internal func rescaledAlmostEqual(to other: Self, tolerance: Self) -> Bool {
    // NaN is considered to be not approximately equal to anything, not even
    // itself.
    if self.isNaN || other.isNaN { return false }
    if self.isInfinite {
      if other.isInfinite { return self == other }
      // Self is infinite and other is finite. Replace self with the binade
      // of the greatestFiniteMagnitude, and reduce the exponent of other by
      // one to compensate.
      let scaledSelf = Self(sign: self.sign,
        exponent: Self.greatestFiniteMagnitude.exponent,
        significand: 1)
      let scaledOther = Self(sign: .plus,
        exponent: -1,
        significand: other)
      // Now both values are finite, so re-run the naive comparison.
      return scaledSelf.isAlmostEqual(to: scaledOther, tolerance: tolerance)
    }
    // If self is finite and other is infinite, flip order and use scaling
    // defined above, since this relation is symmetric.
    return other.rescaledAlmostEqual(to: self, tolerance: tolerance)
  }
}

@inlinable
public func pollardRho<T: SignedInteger>(n: T) -> T? {
  func g(_ x: T, _ n: T) -> T {
    return (x * x + 1) % n
  }

  var (x, y, d) = (T(2), T(2), T(1))
  var (t, z) = (T(0), T(1))
  var count = 0

  while true {
    x = g(x, n)
    y = g(g(y, n), n)
    t = abs(x - y)
    t %= n
    z *= t
    count += 1

    if count == 100 {
      d = z.gcd(with: n)

      if d != 1 {
        break
      }

      z = 1
      count = 0
    }
  }

  return d
}


extension Int {
  fileprivate static let bigNames = [
    1_000: "thousand",
    1_000_000: "million",
    1_000_000_000: "billion",
    1_000_000_000_000: "trillion",
    1_000_000_000_000_000: "quadrillion",
    1_000_000_000_000_000_000: "quintillion"
  ]

  fileprivate static let names = [
    0: "zero",
    1: "one",
    2: "two",
    3: "three",
    4: "four",
    5: "five",
    6: "six",
    7: "seven",
    8: "eight",
    9: "nine",
    10: "ten",
    11: "eleven",
    12: "twelve",
    13: "thirteen",
    14: "fourteen",
    15: "fifteen",
    16: "sixteen",
    17: "seventeen",
    18: "eighteen",
    19: "nineteen",
    20: "twenty",
    30: "thirty",
    40: "forty",
    50: "fifty",
    60: "sixty",
    70: "seventy",
    80: "eighty",
    90: "ninety"
  ]

  private static let irregularOrdinals = [
    "one": "first",
    "two": "second",
    "three": "third",
    "five": "fifth",
    "eight": "eighth",
    "nine": "ninth",
    "twelve": "twelfth"
  ]

  public var numberName: String {
    if let name = Int.names[self] {
      return name
    }

    let neg = self < 0
    let maxNeg = self == Int.min
    var nn: Int

    if maxNeg {
      nn = -(self + 1)
    } else if neg {
      nn = -self
    } else {
      nn = self
    }

    var digits3 = [Int](repeating: 0, count: 7)

    for i in 0..<7 {
      digits3[i] = (nn % 1000)
      nn /= 1000
    }

    let strings = digits3.map(threeDigitsToText)
    var name = strings[0]
    var big = 1000

    for i in 1...6 {
      if digits3[i] > 0 {
        var name2 = "\(strings[i]) \(Int.bigNames[big]!)"

        if name.count > 0 {
          name2 += ", "
        }

        name = name2 + name
      }

      big &*= 1000
    }

    if maxNeg {
      name = String(name.dropLast(5) + "eight")
    }

    return neg ? "minus \(name)" : name
  }
}

private func threeDigitsToText(n: Int) -> String {
  guard n != 0 else {
    return ""
  }

  var ret = ""

  let hundreds = n / 100
  let remainder = n % 100

  if hundreds > 0 {
    ret += "\(Int.names[hundreds]!) hundred"

    if remainder > 0 {
      ret += " "
    }
  }

  if remainder > 0 {
    let tens = remainder / 10
    let units = remainder % 10

    if tens > 1 {
      ret += Int.names[tens * 10]!

      if units > 0 {
        ret += "-\(Int.names[units]!)"
      }
    } else {
      ret += Int.names[remainder]!
    }
  }

  return ret
}
