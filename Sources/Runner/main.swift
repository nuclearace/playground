import BigInt
import CStuff
import Foundation
import Playground

let dividend = 580
let divisor = 34
let (quo, rem) = dividend.egyptianDivide(by: divisor)

print("\(dividend) divided by \(divisor) = \(quo) rem \(rem)")
