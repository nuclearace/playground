import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

let lots = (2...).lazy.filter(isEmirp).prefix(10000)
let rang = (7700...8000).filter(isEmirp)

print("First 20 emirps: \(Array(lots.prefix(20)))")
print("Emirps between 7700 and 8000: \(rang)")
print("10,000th emirp: \(Array(lots).last!)")
