import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let longPi = "3." + DigitsOfPi().prefix(100).dropFirst().lazy.map({ String($0) }).joined()

print(longPi)

guard let p = BigDecimal(longPi) else {
  fatalError()
}

print(p * 2)

let a = BigDecimal(2.0)
let b = BigDecimal(3.0)

print(a / b)
