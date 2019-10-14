//
// Created by Erik Little on 2019-01-23.
//

import Foundation

public let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
public let alphabetSet = Set(alphabet)

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

public struct Vigenere {
  private let keyBytes: [UInt8]
  private let smallestChar: UInt8
  private let largestChar: UInt8
  private let sizeAlphabet: UInt8

  public init?(key: String, smallestCharacter: Character = "A", largestCharacter:  Character = "Z") {

    guard let smallestAscii = smallestCharacter.asciiValue,
          let largestAscii = largestCharacter.asciiValue else {
      return nil
    }

    self.smallestChar = smallestAscii
    self.largestChar = largestAscii
    self.sizeAlphabet = (largestAscii - smallestAscii) + 1

    let bytes = convertToAsciiBytes(str: key, minChar: smallestChar, maxChar: largestChar)

    guard !bytes.isEmpty else {
      return nil
    }

    self.keyBytes = bytes

  }

  public func decrypt(_ str: String) -> String? {
    let txtBytes = convertToAsciiBytes(str: str, minChar: smallestChar, maxChar: largestChar)

    guard !txtBytes.isEmpty else {
      return nil
    }

    var res = ""

    for (i, c) in txtBytes.enumerated() where c >= smallestChar && c <= largestChar {
      let char =
        UnicodeScalar((c &+ sizeAlphabet &- keyBytes[i % keyBytes.count]) % sizeAlphabet &+ smallestChar)

      res += String(char)
    }

    return res
  }

  public func encrypt(_ str: String) -> String? {
    let txtBytes = convertToAsciiBytes(str: str, minChar: smallestChar, maxChar: largestChar)

    guard !txtBytes.isEmpty else {
      return nil
    }

    var res = ""

    for (i, c) in txtBytes.enumerated() where c >= smallestChar && c <= largestChar {
      let char = UnicodeScalar((c &+ keyBytes[i % keyBytes.count] &- 2 &* smallestChar) % sizeAlphabet &+ smallestChar)

      res += String(char)
    }

    return res
  }
}


