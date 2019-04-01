//
// Created by Erik Little on 2019-03-19.
//

public func castOutNines(n: Int) -> Int {
  guard n > 8 else {
    return n
  }

  return castOutNines(n: String(n).map({ Int(String($0))! }).filter({ $0 % 9 != 0 }).reduce(0, +))
}

@inlinable
public func gcd<T: BinaryInteger>(_ a: T, _ b: T) -> T {
  guard a != 0 else {
    return b
  }

  return a < b ? gcd(b % a, a) : gcd(a % b, b)
}
