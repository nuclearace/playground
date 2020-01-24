import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

let ((first, second), t) = ClockTimer.time {
  return pierpoint(n: 2000) as ([BigInt], [BigInt])
}

print("Took \(t.duration)s to find primes.")

print("First 50 1st order pierpoint primes: \(Array(first.prefix(50)))")
print("First 50 2nd order pierpoint primes: \(Array(second.prefix(50)))")

