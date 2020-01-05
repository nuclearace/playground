import BigInt
import CStuff
import Foundation
import Playground
import Numerics

print("Unsigned Lah numbers: L(n, k):")
print("n\\k", terminator: "")

for i in 0...12 {
  print(String(format: "%10d", i), terminator: " ")
}

print()

for row in 0...12 {
  print(String(format: "%-2d", row), terminator: "")

  for i in 0...row {
    lah(n: BigInt(row), k: BigInt(i)).description.withCString {str in
      print(String(format: "%11s", str), terminator: "")
    }
  }

  print()
}

let maxLah = (0...100).map({ lah(n: BigInt(100), k: BigInt($0)) }).max()!

print("Maximum value from the L(100, *) row: \(maxLah)")
