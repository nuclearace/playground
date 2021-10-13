//
// Created by Erik Little on 10/13/21.
//

import BigNumber
import Foundation

public func sylvester(n: Int) -> BInt {
  var a = BInt(2)

  for _ in 0..<n {
    a = a * a - a + 1
  }

  return a
}
