import ArgumentParser
//import AsyncHTTPClient
import BigInt
import CryptoSwift
import BigNumber
import ClockTimer
// import CGMP
import CStuff
import Foundation
import Playground
import Numerics

var sum = BDouble(0)

for n in 0..<10 {
  let syl = sylvester(n: n)
  sum += BDouble(1) / BDouble(syl)
  print(syl)
}

print("Sum of the reciprocals of first ten in sequence: \(sum)")
