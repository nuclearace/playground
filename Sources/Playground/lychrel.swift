//
// Created by Erik Little on 11/27/19.
//

import BigInt
import Foundation

public protocol ReversibleNumeric: Numeric {
  func reversed() -> Self
}

extension Int: ReversibleNumeric {
  public func reversed() -> Int {
    return Int(String(description.reversed()))!
  }
}

extension BigInt: ReversibleNumeric {
  public func reversed() -> BigInt {
    return BigInt(String(description.reversed()))!
  }
}

public struct Lychrel<T: ReversibleNumeric & CustomStringConvertible>: Sequence, IteratorProtocol {
  @usableFromInline
  let seed: T

  @usableFromInline
  var done = false

  @usableFromInline
  var n: T

  @usableFromInline
  var iterations: T

  @inlinable
  public init(seed: T, iterations: T = 500) {
    self.seed = seed
    self.n = seed
    self.iterations = iterations
  }

  @inlinable
  public mutating func next() -> T? {
    guard !done && iterations != 0 else {
      return nil
    }

    guard !isPalindrome(n) || n == seed else {
      done = true

      return n
    }

    defer {
      n += n.reversed()
      iterations -= 1
    }

    return n
  }
}

public enum LychrelResult<T: BinaryInteger> {
  case finished([T])
  case stopped([T])

  public var values: [T] {
    switch self {
    case let .stopped(vals):
      return vals
    case let.finished(vals):
      return vals
    }
  }
}

@inlinable
public func lychrel<T: ReversibleNumeric>(n: T, iterations: Int = 500) -> LychrelResult<T> {
  var work = n + n.reversed() // Do first iteration to handle already palindromic values
  var i = 1
  var res = [n, work]

  while !isPalindrome(work) && i < iterations {
    work += work.reversed()

    res.append(work)

    i += 1
  }

  return isPalindrome(res.last!) ? .finished(res) : .stopped(res)
}
