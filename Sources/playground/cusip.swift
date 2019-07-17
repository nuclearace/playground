//
// Created by Erik Little on 2019-07-17.
//

public struct CUSIP {
  public var value: String

  private static let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

  public init?(value: String) {
    if value.count == 9 && String(value.last!) == CUSIP.checkDigit(cusipString: String(value.dropLast())) {
      self.value = value
    } else if value.count == 8, let checkDigit = CUSIP.checkDigit(cusipString: value) {
      self.value = value + checkDigit
    } else {
      return nil
    }
  }

  public static func checkDigit(cusipString: String) -> String? {
    guard cusipString.count == 8, cusipString.allSatisfy({ $0.isASCII }) else {
      return nil
    }

    let sum = cusipString.uppercased().lazy.enumerated().reduce(0, {sum, pair in
      let (i, char) = pair
      var v: Int

      switch char {
      case "*":
        v = 36
      case "@":
        v = 37
      case "#":
        v = 38
      case _ where char.isNumber:
        v = char.wholeNumberValue!
      case _:
        v = Int(char.asciiValue! - 65) + 10
      }

      if i & 1 == 1 {
        v *= 2
      }

      return sum + (v / 10) + (v % 10)
    })

    return String((10 - (sum % 10)) % 10)
  }
}
