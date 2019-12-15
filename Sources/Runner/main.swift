import BigInt
import CStuff
import Foundation
import Playground
import Numerics

let powerOf2 = 2500
let queue = DispatchQueue(label: "work", attributes: .concurrent)
let lock = DispatchSemaphore(value: 1)

var n = BigInt(2).power(powerOf2)
var probablePrimes = 0
var nonPrimes = 0
var pCache = [Int: BigInt]()

for i in 0..<powerOf2 {
  pCache[i] = BigInt(2).power(BigInt(i))
}

print("running")

func primeSearch() {
  queue.async {
    lock.wait()
    let localN = n

    n += 1
    lock.signal()

    let (probablyPrime, t) = ClockTimer.time({ localN.isProbablePrime(powerOf2Cache: pCache) })

    lock.wait()
    if probablyPrime {
      print("\(localN) is probably prime. Checking took \(t.duration)s")

      probablePrimes += 1

      if probablePrimes == 10 {
        exit(0)
      }
    } else {
      nonPrimes += 1
    }

    if nonPrimes.isMultiple(of: 100) {
      print("found \(probablePrimes) probable primes; found \(nonPrimes) non-primes")
    }
    lock.signal()

    primeSearch()
  }
}


for _ in 0..<ProcessInfo.processInfo.processorCount {
  primeSearch()
}

dispatchMain()
