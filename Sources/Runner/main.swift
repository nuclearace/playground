import BigInt
import CStuff
import Foundation
import Playground
import Numerics

let zums = (2...).lazy.filter({ $0.isZumkeller })
let oddZums = zums.filter({ $0 & 1 == 1 })
let oddZumsWithout5 = oddZums.filter({ String($0).last! != "5" })

print("First 220 zumkeller numbers are: \(Array(zums.prefix(220)))")
print("First 40 odd zumkeller numbers are: \(Array(oddZums.prefix(40)))")
print("First 40 odd zumkeller numbers that don't end in a 5 are: \(Array(oddZumsWithout5.prefix(40)))")
