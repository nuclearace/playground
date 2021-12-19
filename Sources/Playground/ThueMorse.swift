//
// Created by Erik Little on 12/19/21.
//

import Foundation

public struct ThueMorse: Sequence, IteratorProtocol {
  private var seq = ""

  public init() {}

  public mutating func next() -> String? {
    guard !seq.isEmpty else {
      seq = "0"

      return seq
    }

    for b in seq {
      seq += b == "0" ? "1" : "0"
    }

    return seq
  }
}
