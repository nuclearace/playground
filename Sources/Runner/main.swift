import BigInt
import CStuff
import Foundation
import Playground
import Numerics

func continuedFraction<T: Sequence, V: Sequence>(
  _ seq1: T,
  _ seq2: V,
  iterations: Int = 1000
) -> Double where T.Element: BinaryInteger, T.Element == V.Element {
  return zip(seq1, seq2).prefix(iterations).reversed().reduce(0.0, { Double($1.0) + (Double($1.1) / $0) })
}

let sqrtA = [1].chained(with: [2].cycled())
let sqrtB = [1].cycled()

print("√2 ≈ \(continuedFraction(sqrtA, sqrtB))")

let napierA = [2].chained(with: 1...)
let napierB = [1].chained(with: 1...)

print("e ≈ \(continuedFraction(napierA, napierB))")

let piA = [3].chained(with: [6].cycled())
let piB = (1...).lazy.map({ (2 * $0 - 1).power(2) })

print("π ≈ \(continuedFraction(piA, piB))")
