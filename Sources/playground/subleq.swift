//
// Created by Erik Little on 2019-09-19.
//

import Foundation

public func subleq(_ inst: inout [Int]) {
  var i = 0

  while i >= 0 {
    if inst[i] == -1 {
      inst[inst[i + 1]] = Int(readLine(strippingNewline: true)!.unicodeScalars.first!.value)
    } else if inst[i + 1] == -1 {
      print(String(UnicodeScalar(inst[inst[i]])!), terminator: "")
    } else {
      inst[inst[i + 1]] -= inst[inst[i]]

      if inst[inst[i + 1]] <= 0 {
        i = inst[i + 2]
        continue
      }
    }

    i += 3
  }
}

