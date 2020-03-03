import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

for i in 1...10 {
  print("\(i): \(classifySequence(k: i))")
}

print()

for i in [11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488] {
  print("\(i): \(classifySequence(k: i))")
}

print()

print("\(15355717786080): \(classifySequence(k: 15355717786080))")
