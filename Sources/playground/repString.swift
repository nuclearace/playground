//
// Created by Erik Little on 2019-07-11.
//

import Foundation

public func repString(_ input: String) -> [String] {
  return (1..<(1 + input.count / 2)).compactMap({x -> String? in
    let i = input.index(input.startIndex, offsetBy: x)
    return input.hasPrefix(input[i...]) ? String(input.prefix(x)) : nil
  })
}
