import BigInt
import CStuff
import Foundation
import Playground

for prime in Eratosthenes(upTo: 60) {
  let m = Int(pow(2, Double(prime))) - 1
  let (decom, t) = ClockTimer.time {
//    return primeDecomposition(of: m)
    return m.primeDecomposition()
  }

  print("2^\(prime) - 1 = \(m) => \(decom). Took \(t)")
}
