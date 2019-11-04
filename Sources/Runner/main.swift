import BigInt
import CStuff
import Foundation
import Playground

for n in 0...60 {
  let b = bernoulli(n: n) as Frac<BigInt>

  guard b != 0 else {
    continue
  }

  print("B(\(n)) = \(b)")
}
