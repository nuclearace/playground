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
  private let keyScalars: [UInt32]
  private let smallestScalar: UInt32
  private let largestScalar: UInt32
  private let sizeAlphabet: UInt32

  public init?(key: String, smallestCharacter: Character = "A", largestCharacter:  Character = "Z") {
    let smallScalars = smallestCharacter.unicodeScalars
    let largeScalars = largestCharacter.unicodeScalars

    guard smallScalars.count == 1, largeScalars.count == 1 else {
      return nil
    }

    self.smallestScalar = smallScalars.first!.value
    self.largestScalar = largeScalars.first!.value
    self.sizeAlphabet = (largestScalar - smallestScalar) + 1

    let scalars = convertToUnicodeScalars(str: key, minChar: smallestScalar, maxChar: largestScalar)

    guard !scalars.isEmpty else {
      return nil
    }

    self.keyScalars = scalars

  }

  public func decrypt(_ str: String) -> String? {
    let txtBytes = convertToUnicodeScalars(str: str, minChar: smallestScalar, maxChar: largestScalar)

    guard !txtBytes.isEmpty else {
      return nil
    }

    var res = ""

    for (i, c) in txtBytes.enumerated() where c >= smallestScalar && c <= largestScalar {
      guard let char =
        UnicodeScalar((c &+ sizeAlphabet &- keyScalars[i % keyScalars.count]) % sizeAlphabet &+ smallestScalar)
      else {
        return nil
      }

      res += String(char)
    }

    return res
  }

  public func encrypt(_ str: String) -> String? {
    let txtBytes = convertToUnicodeScalars(str: str, minChar: smallestScalar, maxChar: largestScalar)

    guard !txtBytes.isEmpty else {
      return nil
    }

    var res = ""

    for (i, c) in txtBytes.enumerated() where c >= smallestScalar && c <= largestScalar {
      guard let char =
        UnicodeScalar((c &+ keyScalars[i % keyScalars.count] &- 2 &* smallestScalar) % sizeAlphabet &+ smallestScalar)
      else {
        return nil
      }

      res += String(char)
    }

    return res
  }
}


