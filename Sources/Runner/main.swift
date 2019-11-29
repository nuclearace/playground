import BigInt
import CStuff
import Foundation
import Playground
import Numerics

let narcs = Array((0...).lazy.filter({ $0.isNarcissistic }).prefix(25))

print("First 25 narcissistic numbers are \(narcs)")

