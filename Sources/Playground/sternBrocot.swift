//
// Created by Erik Little on 2019-04-01.
//

public struct SternBrocot: Sequence, IteratorProtocol {
  private var seq = [1, 1]

  public init() { }

  public mutating func next() -> Int? {
    seq += [seq[0] + seq[1], seq[1]]

    return seq.removeFirst()
  }
}

public func fusc<T: BinaryInteger>(n: T) -> T {
  guard n > 1 else {
    return n
  }

  if n & 1 == 0 {
    return fusc(n: n / 2)
  } else {
    return fusc(n: (n - 1) / 2) + fusc(n: (n + 1) / 2)
  }
}
