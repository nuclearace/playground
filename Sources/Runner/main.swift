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

//let a = BigDecimal(10)
//let b = BigDecimal(11)
let d = bigPi / BigDecimal("0.000005")!
let ans = BigDecimal("0.0000523598775598298873077107230546583814032861566562517636829157432051302734381034833104672470890352844")!

print(d)
print(d.scale)
print(d.precision)
print(ans.scale)
print(ans.precision)
print(ans == bigPi / 60000)
