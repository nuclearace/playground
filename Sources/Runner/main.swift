import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

let first = FuscSeq().prefix(61)

print("First 61: \(Array(first))")

var max = -1

for (i, n) in FuscSeq().prefix(20_000_000).enumerated() {
  let f = String(n).count

  if f > max {
    max = f

    print("New max: \(i): \(n)")
  }
}
