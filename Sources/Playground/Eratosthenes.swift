//
// Created by Erik Little on 9/17/18.
//

import Foundation

public struct Eratosthenes: Sequence, IteratorProtocol {
  private let n: Int
  private let limit: Int

  private var i = 2
  private var sieve: [Int]

  public init(upTo: Int) {
    if upTo <= 1 {
      n = 0
      limit = -1
      sieve = []
    } else {
      n = upTo
      limit = Int(Double(n).squareRoot())
      sieve = Array(0...n)
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

public struct EratosthenesOddsOnly: Sequence, IteratorProtocol {
  @usableFromInline
  var basePrimes = [2, 3, 5, 7]

  @usableFromInline
  var initial = true

  @usableFromInline
  var p = 3, q = 9, n = 9, i = 0

  @usableFromInline
  var sieve = [Int: Int]()

  public init() {}

  @inlinable
  public mutating func next() -> Int? {
    if basePrimes.isEmpty {
      initial = false
      basePrimes = [5, 7]
    } else if initial {
      return basePrimes.removeFirst()
    }

    while true {
      if sieve[n] == nil {
        if n < q {
          let ret = n

          basePrimes.append(ret)
          n += 2

          return ret
        } else {
          let p2 = p + p
          sieve[q + p2] = p2
          p = basePrimes[i]
          i += 1
          q = p * p
        }
      } else {
        let s = sieve.removeValue(forKey: n)!
        var next = n + s

        while sieve[next] != nil {
          next += s
        }

        sieve[next] = s
      }

      n += 2
    }
  }
}

public func eratosthenes(limit: Int) -> [Int] {
  guard limit >= 3 else {
    return limit < 2 ? [] : [2]
  }

  let ndxLimit = (limit - 3) / 2 + 1
  let bufSize = ((limit - 3) / 2) / 32 + 1
  let sqrtNdxLimit = (Int(Double(limit).squareRoot()) - 3) / 2 + 1
  var cmpsts = Array(repeating: 0, count: bufSize)

  for ndx in 0..<sqrtNdxLimit where (cmpsts[ndx >> 5] & (1 << (ndx & 31))) == 0 {
    let p = ndx + ndx + 3
    var cullPos = (p * p - 3) / 2

    while cullPos < ndxLimit {
      cmpsts[cullPos >> 5] |= 1 << (cullPos & 31)

      cullPos += p
    }
  }

  return (-1..<ndxLimit).compactMap({i -> Int? in
    if i < 0 {
      return 2
    } else {
      if cmpsts[i >> 5] & (1 << (i & 31)) == 0 {
        return .some(i + i + 3)
      } else {
        return nil
      }
    }
  })
}
