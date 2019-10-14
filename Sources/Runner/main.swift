import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

for n in 1...10_000_000 {
  print("\u{001B}[2J\u{001B}[f", terminator: "")
  print("\(n) prime?: ", terminator: "")

  let nIsPrime = n.isPrime

  print(nIsPrime)

  print("\(n) MR Test: ", terminator: "")

  let aksThinks = BigInt(n).isPrime(rounds: 20)

  print(aksThinks)
  print()

  if nIsPrime != aksThinks {
    fatalError()
  }

  Thread.sleep(forTimeInterval: 0.005)
}
