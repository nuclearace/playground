//
// Created by Erik Little on 9/17/18.
//

public struct Eratosthenes: Sequence, IteratorProtocol {
  private let n: Int
  private let limit: Int

  private var i = 2
  private var sieve: [Int]

  public init(upTo: Int) {
    if upTo <= 1 {
      self.n = 0
      self.limit = -1
      self.sieve = []
    } else {
      self.n = upTo
      self.limit = Int(Double(n).squareRoot())
      self.sieve = Array(0...n)
    }
  }

  public mutating func next() -> Int? {
    while i < n {
      defer { i += 1 }

      if sieve[i] != 0 {
        if i <= limit {
          for notPrime in stride(from: i * i, through: n, by: i) {
            sieve[notPrime] = 0
          }
        }

        return i
      }
    }

    return nil
  }
}
