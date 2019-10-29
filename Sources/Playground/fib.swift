//
// Created by Erik Little on 2018-11-08.
//

import BigInt

public func fib(n: Int) -> BigInt {
  return lucasSeq(1, 1, n: n)
}

public func lucas(n: Int) -> BigInt {
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

public func lucasSeq(_ p: Int, _ q: Int, n: Int) -> BigInt {
  var a = BigInt(p), b = BigInt(q)

  for _ in 0..<n {
    (a, b) = (b, a + b)
  }

  return a
}
