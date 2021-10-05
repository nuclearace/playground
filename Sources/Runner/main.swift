import ArgumentParser
//import AsyncHTTPClient
import BigInt
import ClockTimer
// import CGMP
import CStuff
import Foundation
import Playground
import Numerics

for base in 2...16 {
  let esthetics = (0...)
    .lazy
    .map({ String($0, radix: base) })
    .filter({ $0.isEsthetic(base: base) })
    .dropFirst(base * 4)
    .take((base * 6) - (base * 4) + 1)

  print("Base \(base) esthetics from \(base * 4) to \(base * 6)")
  print(esthetics)
  print()
}

let base10Esthetics = (1000...9999).filter({ String($0).isEsthetic() })

print("\(base10Esthetics.count) esthetics between 1000 and 9999:")
print(base10Esthetics)
print()

func printSlice(of array: [String]) {
  print(array.take(5))
  print("...")
  print(Array(array.lazy.reversed().take(5).reversed()))
  print("\(array.count) total\n")
}

print("Esthetics between \(Int(1e8)) and \(13 * Int(1e7)):")
printSlice(of: getEsthetics(from: Int(1e8), to: 13 * Int(1e8)))

print("Esthetics between \(Int(1e11)) and \(13 * Int(1e10))")
printSlice(of: getEsthetics(from: Int(1e11), to: 13 * Int(1e10)))

print("Esthetics between \(Int(1e14)) and \(13 * Int(1e13)):")
printSlice(of: getEsthetics(from: Int(1e14), to: 13 * Int(1e13)))

print("Esthetics between \(Int(1e17)) and \(13 * Int(1e16)):")
printSlice(of: getEsthetics(from: Int(1e17), to: 13 * Int(1e16)))
