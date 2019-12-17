import BigInt
import CStuff
import Foundation
import Playground
import Numerics

let oddAbundant = (0...).lazy.filter({ $0 & 1 == 1 }).map({ ($0, isAbundant(n: $0)) }).filter({ $1.0 })

for (n, (_, factors)) in oddAbundant.prefix(25) {
  print("n: \(n); sigma: \(factors.reduce(0, +))")
}

let (bigA, (_, bigFactors)) =
  (1_000_000_000...)
    .lazy
    .filter({ $0 & 1 == 1 })
    .map({ ($0, isAbundant(n: $0)) })
    .first(where: { $1.0 })!

print("first odd abundant number over 1 billion: \(bigA), sigma: \(bigFactors.reduce(0, +))")
