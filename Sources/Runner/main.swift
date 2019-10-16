import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let longPi = "3." + DigitsOfPi().prefix(100).dropFirst().lazy.map({ String($0) }).joined()

print(longPi)

guard let bigPi = BigDecimal(longPi) else {
  fatalError()
}

print(bigPi * 2)

let a = BigDecimal(10)
let b = BigDecimal(11)

print(a / b)
