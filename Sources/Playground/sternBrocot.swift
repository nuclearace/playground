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

public struct FuscSeq: Sequence, IteratorProtocol {
  private var arr = [0, 1]
  private var i = 0

  public init() {}

  public mutating func next() -> Int? {
    defer {
      i += 1
    }

    guard i > 1 else {
      return arr[i]
    }

    switch i & 1 {
    case 0:
      arr.append(arr[i / 2])
    case 1:
      arr.append(arr[(i - 1) / 2] + arr[(i + 1) / 2])
    case _:
      fatalError()
    }

    return arr.last!
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
