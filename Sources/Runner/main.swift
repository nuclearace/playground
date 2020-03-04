import BigInt
import ClockTimer
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

var sum = BigInt(0)

for i in (1...100).chained(with: 400...500).chained(with: 200...444).chained(with: (Int.max-20)...Int.max) {
  sum += BigInt(i)
}

print(sum)
