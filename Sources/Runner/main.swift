import BigInt
import CStuff
import Foundation
import Playground
import Numerics

func primeFactors(n: BigInt) -> (BigInt, BigInt)? {
  if n.isPrime(rounds: 10) {
    return nil
  }

  guard let factor1 = pollardRho(n: n) else {
    fatalError()
  }

  guard factor1.isPrime(rounds: 10) else {
    fatalError()
  }

  let factor2 = n / factor1

  guard factor2.isPrime(rounds: 10) else {
    fatalError()
  }

  return (factor1, factor2)
}

let first10Fermat = fermatNumbers(n: BigInt(10))

print("The first ten fermat numbers are:")

for (i, n) in first10Fermat.enumerated() {
  print("F(\(i)) = \(n)")
}

print("Prime factors of first ten fermat numbers:")

for (i, n) in first10Fermat.enumerated() {
  print("F(\(i)) = \(n) => ", terminator: "")

  fflush(stdout)

  guard case let (factors?, t) = ClockTimer.time({ primeFactors(n: n) }) else {
    print("prime")

    continue
  }

  print("\(factors); took \(t.duration)s")
}
