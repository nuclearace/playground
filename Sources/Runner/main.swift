import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

var x = BigInt(0)
var y = BigInt(0)

for n in 2..<10_000 {
  if n.isSquare {
    print("square \(n)")

    continue
  } else if isPrime(BigInt(n)) {
    print("prime \(n)")
  }

  solvePell(n: BigInt(n), &x, &y)

  print("x\u{00b2} - \(n)y\u{00b2} = 1 for x = \(x) and y = \(y)")
}
