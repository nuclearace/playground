//
// Created by Erik Little on 2019-06-26.
//

import Foundation

public func ackermann(m: Int, n: Int) -> Int {
  switch (m, n) {
  case (0, _):
    return n + 1
  case (_, 0):
    return ackermann(m: m - 1, n: 1)
  case (_, _):
    return ackermann(m: m - 1, n: ackermann(m: m, n: n - 1))
  }
}
