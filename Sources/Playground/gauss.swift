//
// Created by Erik Little on 2/28/20.
//

import Foundation

public func gaussEliminate(_ sys: [[Double]]) -> [Double]? {
  var system = sys

  let size = system.count

  for i in 0..<size-1 where system[i][i] != 0 {
    for j in i..<size-1 {
      let factor = system[j + 1][i] / system[i][i]

      for k in i..<size+1 {
        system[j + 1][k] -= factor * system[i][k]
      }
    }
  }

  for i in (1..<size).reversed() where system[i][i] != 0 {
    for j in (1..<i+1).reversed() {
      let factor = system[j - 1][i] / system[i][i]

      for k in (0..<size+1).reversed() {
        system[j - 1][k] -= factor * system[i][k]
      }
    }
  }

  var solutions = [Double]()

  for i in 0..<size {
    guard system[i][i] != 0 else {
      return nil
    }

    system[i][size] /= system[i][i]
    system[i][i] = 1
    solutions.append(system[i][size])
  }

  return solutions
}
