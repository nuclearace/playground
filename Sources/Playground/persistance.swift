//
// Created by Erik Little on 2019-03-21.
//

import Foundation

public func per(_ n: Int) -> (final: Int, length: Int) {
  return perR(n, count: 0)
}

private func perR(_ n: Int, count: Int)  -> (final: Int, length: Int) {
  print(n)

  guard String(n).count != 1 else {
    return (n, count)
  }

  return perR(String(n).map({ Int(String($0))! }).reduce(1, *), count: count + 1)
}

