//
// Created by Erik Little on 2018-11-08.
//

import BigInt

public func fib(n: Int) -> BigInt {
  var a = BigInt(0), b = BigInt(1)

  for _ in 0..<n {
    (a, b) = (b, a + b)
  }

  return a
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
