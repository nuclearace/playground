import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

prefix func ! <T: BinaryInteger>(n: T) -> T {
  guard n != 0 else {
    return 0
  }

  return stride(from: 0, to: n, by: 1).lazy.map(factorial).reduce(0, +)
}

for i in 0...10 {
  print("!\(i) = \(!i)")
}

print()

for i in stride(from: BigInt(20), through: 110, by: 10) {
  print("!\(i) = \(!i)")
}

print()

print("!1000 = \((!BigInt(1000)).description.count) digit number")

print()

for i in stride(from: BigInt(2000), through: 10_000, by: 1000) {
  print("!\(i) = \((!i).description.count) digit number")
}
