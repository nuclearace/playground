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

@inlinable
public func + <T>(el: T, arr: [T]) -> [T] {
  var ret = arr

  ret.insert(el, at: 0)

  return ret
}

@inlinable
public func cartesianProduct<T>(_ arrays: [T]...) -> [[T]] {
  guard let head = arrays.first else {
    return []
  }

  let first = Array(head)

  func pel(
    _ el: T,
    _ ll: [[T]],
    _ a: [[T]] = []
  ) -> [[T]] {
    switch ll.count {
    case 0:
      return a.reversed()
    case _:
      let tail = Array(ll.dropFirst())
      let head = ll.first!

      return pel(el, tail, el + head + a)
    }
  }

  return arrays.lazy.reversed()
    .reduce([first], {res, el in el.flatMap({ pel($0, res) }) })
    .map({ $0.dropLast(first.count) })
}
