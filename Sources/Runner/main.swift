import BigInt
import CStuff
import Foundation
import Playground

var num = 0
var denom = 0

for base in 2...5 {
  print("base \(base): 0 ", terminator: "")

  for n in 1..<10 {
    vanDerCorput(n: n, base: base, num: &num, denom: &denom)

    print("\(num)/\(denom) ", terminator: "")
  }

  print()
}
