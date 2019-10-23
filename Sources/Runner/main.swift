import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let num = 15

let tri = BellTriangle<Int>(n: num)

print("First 15 Bell numbers:")

for i in 1...num  {
  let n = tri[row: i, col: 0]

  print("\(i + 1): \(n)")
}

for i in 1...10 {
  print(tri[row: i, col: 0], terminator: "")

  for j in 1..<i {
    print(", \(tri[row: i, col: j])", terminator: "")
  }

  print()
}
