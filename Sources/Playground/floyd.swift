//
// Created by Erik Little on 2018-12-06.
//

import Foundation

public func floyd(numRows n: Int) -> [[Int]] {
  var rows = [[]] as [[Int]]
  var lastInRow = 1
  var i = 1

  while rows.count <= n {
    rows[rows.count-1].append(i)

    if i == lastInRow {
      rows.append([])
      lastInRow += rows.count
    }

    i += 1
  }

  return Array(rows.dropLast())
}
