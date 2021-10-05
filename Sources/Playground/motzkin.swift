//
// Created by Erik Little on 10/1/21.
//

import Foundation

public func motzkin(_ n: Int) -> [Int] {
  var m = Array(repeating: 0, count: n)

  m[0] = 1
  m[1] = 1

  for i in 2..<n {
    m[i] = (m[i - 1] * (2 * i + 1) + m[i - 2] * (3 * i - 3)) / (i + 2)
  }

  return m
}
