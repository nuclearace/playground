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
