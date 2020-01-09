import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

for k in 1..<6 {
  print("\(k): \(Array(KPrimeGen(k: k, n: 1).lazy.prefix(10)))")
}
