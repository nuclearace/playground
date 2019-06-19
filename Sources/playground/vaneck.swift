//
// Created by Erik Little on 2019-06-11.
//

import Foundation

public struct VanEck: Sequence, IteratorProtocol {
  private var seq = [Int]()

  public init() {}

  public mutating func next() -> Int? {
    guard !seq.isEmpty else {
      seq.append(0)

      return 0
    }

    let lastNum = seq.last!
    let lastIndex = seq.index(before: seq.endIndex)

    if let lastSeen = seq[..<lastIndex].lastIndex(of: lastNum) {
      seq.append(seq.distance(from: lastSeen, to: lastIndex))
    } else {
      seq.append(0)
    }

    return seq.last!
  }
}
