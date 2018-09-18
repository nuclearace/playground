import BigInt
import Playground

let primes = Array(Eratosthenes(upTo: 1_000_001))

func primordial(n: Int) -> BigUInt {
  return primes.prefix(n).reduce(BigUInt(1), { $0 * BigUInt($1) })
}

for (offset, element) in (0...9).lazy.map(primordial).enumerated() {
  print("primordial(\(offset)) -> \(element)")
}

for (n, primordialN) in [10, 100, 1_000, 10_000, 100_000, /*1_000_000*/].lazy.map({ ($0, primordial(n: $0)) }) {
  print("primordial(\(n)) -> has \(primordialN.description.count) digits")
}
