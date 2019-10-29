//
// Created by Erik Little on 2018-10-14.
//

import Foundation

extension RandomAccessCollection where Self: MutableCollection, Element: Numeric, Index == Int {
  @inlinable
  public mutating func walshHadamardTransformation() {
    assert((count & (count - 1)) == 0, "Invalid matrix size")

    var h = 1

    while h < count {
      for i in stride(from: 0, to: count, by: h * 2) {
        for j in i..<i+h {
          let x = self[j]
          let y = self[j+h]

          self[j] = x + y
          self[j+h] = x - y
        }
      }

      h *= 2
    }
  }

  @inlinable
  public func walshHadamardTransformed() -> Self {
    var ret = self

    ret.walshHadamardTransformation()

    return ret
  }
}
