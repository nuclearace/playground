//
// Created by Erik Little on 9/8/18.
//

import Foundation

public func isMünchhausen(_ n: Int) -> Bool {
  let nums = String(n).map(String.init).compactMap(Int.init)

  return Int(nums.map({ pow(Double($0), Double($0)) }).reduce(0, +)) == n
}
