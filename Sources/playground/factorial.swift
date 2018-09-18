//
// Created by Erik Little on 9/1/18.
//

import BigInt

public func factorial(_ n: Int) -> BigInt {
  return (1...n).map({ BigInt($0) }).reduce(1, *)
}
