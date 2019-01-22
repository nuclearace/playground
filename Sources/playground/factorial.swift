//
// Created by Erik Little on 9/1/18.
//

import BigInt

public func factorial(_ n: Int) -> BigInt {
  return (1...n).map({ BigInt($0) }).reduce(1, *)
}

public func multiFactorial(_ n: Int, k: Int) -> BigInt {
  return stride(from: n, to: 0, by: -k).map({ BigInt($0) }).reduce(1, *)
}
