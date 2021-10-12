import ArgumentParser
//import AsyncHTTPClient
import BigInt
import CryptoSwift
//import BigNumber
import ClockTimer
// import CGMP
import CStuff
import Foundation
import Playground
import Numerics

for (i, n) in XorshiftStar(seed: 1234567).lazy.enumerated().prefix(5) {
  print("\(i): \(n)")
}

var gen = XorshiftStar(seed: 987654321)
var counts = [Float: Int]()

for _ in 0..<100_000 {
  counts[floorf(gen.nextFloat() * 5), default: 0] += 1
}

print(counts)
