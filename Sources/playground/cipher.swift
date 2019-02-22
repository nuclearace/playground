//
// Created by Erik Little on 2019-01-23.
//

import Foundation

public let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")

public struct SubstitutionCipher {
  public var key: [Character]

  public init(key: [Character] = alphabet.shuffled()) {
    self.key = key
  }

  public func encode(string: String) -> String {
    var res = ""

    for char in string {
      res += String(key[alphabet.firstIndex(where: { $0 == char })!])
    }

    return res
  }

  public func decode(string: String) -> String {
    var res = ""

    for char in string {
      res += String(alphabet[key.firstIndex(where: { $0 == char })!])
    }

    return res
  }
}

