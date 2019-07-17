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

extension Array {
  public mutating func satalloShuffle() {
    for i in stride(from: index(before: endIndex), through: 1, by: -1) {
      swapAt(i, .random(in: 0..<i))
    }
  }

  public func satalloShuffled() -> [Element] {
    var arr = Array(self)

    arr.satalloShuffle()

    return arr
  }
}
