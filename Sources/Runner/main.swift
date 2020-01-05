import BigInt
import CStuff
import Foundation
import Playground
import Numerics

func findPeriod(n: Int) -> Int {
  let r = (1...n+1).reduce(1, {res, _ in (10 * res) % n })
  var rr = r
  var period = 0

  repeat {
    rr = (10 * rr) % n
    period += 1
  } while r != rr

  return period
}

let longPrimes = Eratosthenes(upTo: 64000).dropFirst().lazy.filter({ findPeriod(n: $0) == $0 - 1 })

print("Long primes less than 500: \(Array(longPrimes.prefix(while: { $0 <= 500 })))")

let counts =
  longPrimes.reduce(into: [500: 0, 1000: 0, 2000: 0, 4000: 0, 8000: 0, 16000: 0, 32000: 0, 64000: 0], {counts, n in
    for key in counts.keys where n < key {
      counts[key]! += 1
    }
  })

for key in counts.keys.sorted() {
  print("There are \(counts[key]!) long primes less than \(key)")
}
