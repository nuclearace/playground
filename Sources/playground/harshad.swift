//
// Created by Erik Little on 2019-04-25.
//

import Foundation

public struct Harshad: Sequence, IteratorProtocol {
  private var i = 0

  public init() {}

  public mutating func next() -> Int? {
    while true {
      i += 1

      if i % Array(String(i)).map(String.init).compactMap(Int.init).reduce(0, +) == 0 {
        return i
      }
    }
  }
}
