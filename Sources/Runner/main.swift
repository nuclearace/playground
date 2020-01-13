import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

func binomial<T: BinaryInteger>(_ x: (n: T, k: T)) -> T {
  let nFac = factorial(x.n)
  let kFac = factorial(x.k)

  return nFac / (factorial(x.n - x.k) * kFac)
}

print("binomial(\(5), \(3)) = \(binomial((5, 3)))")
print("binomial(\(20), \(11)) = \(binomial((20, 11)))")
