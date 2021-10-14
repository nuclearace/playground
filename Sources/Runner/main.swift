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

let cubes = (1...).lazy.map({ $0 * $0 * $0 })
let taxis =
  Array(cubes.prefix(1201))
    .combinations(2)
    .reduce(into: [Int: [[Int]]](), { $0[$1[0] + $1[1], default: []].append($1) })


let res =
  taxis
    .lazy
    .filter({ $0.value.count > 1 })
    .sorted(by: { $0.key < $1.key })
    .map({ ($0.key, $0.value) })
    .prefix(2006)

print("First 25 taxicab numbers:")
for taxi in res[..<25] {
  print(taxi)
}

print("\n2000th through 2006th taxicab numbers:")
for taxi in res[1999..<2006] {
  print(taxi)
}
