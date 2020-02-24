import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

print("n/a  0  1  2  3  4  5  6  7  8  9")
print("---------------------------------")

for n in stride(from: 1, through: 17, by: 2) {
  print(String(format: "%2d", n), terminator: "")

  for a in 0..<10 {
    print(String(format: " % d", jacobi(a: a, n: n)), terminator: "")
  }

  print()
}
