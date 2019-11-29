//
// Created by Erik Little on 2018-11-08.
//

import BigInt

public func fib<T: BinaryInteger>(n: T) -> T {
  return lucasSeq(1, 1, n: n)
}

public func lucas<T: BinaryInteger>(n: T) -> T {
  return lucasSeq(2, 1, n: n)
}

public func fibRecursive(n: Int) -> BigInt {
  assert(n >= 0)

  if n <= 1 {
    return BigInt(n)
  }

  return fibRecursive(n: n - 1) + fibRecursive(n: n - 2)
}

public struct FibonacciSequence : Sequence, IteratorProtocol {
  private var a = BigInt(0)
  private var b = BigInt(1)

  public init() { }

  public mutating func next() -> BigInt? {
    (a, b) = (b, a + b)

    return a
  }
}

public func lucasSeq<T: BinaryInteger>(_ p: T, _ q: T, n: T) -> T {
  var a = p, b = q

  for _ in stride(from: 0, to: n, by: 1) {
    (a, b) = (b, a + b)
  }

  return a
}
