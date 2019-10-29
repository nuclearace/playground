//
// Created by Erik Little on 2018-10-18.
//

import Foundation

extension String {
  public mutating func wordWrap(lineWidth: Int = 120) {
    var curLength = 0

    for i in indices {
      guard curLength + 1 > lineWidth else {
        curLength += 1
        continue
      }
      guard index(after: i) == endIndex || self[index(after: i)] == " " else {
        continue
      }

      guard let lastSpace = self[...i].lastIndex(of: " ") else { break }

      insert("\n", at: index(after: lastSpace))
      curLength = 0
    }
  }

  public func wordWrapped(lineWidth: Int = 120) -> String {
    var ret = self

    ret.wordWrap(lineWidth: lineWidth)

    return ret
  }
}
