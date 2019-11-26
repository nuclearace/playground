import BigInt
import CStuff
import Foundation
import Playground
import Numerics

private let ludicNumbers = Array(Ludic().prefix(2005))

print("First 25 ludic numbers are \(Array(ludicNumbers.prefix(25)))")
print("\(ludicNumbers.prefix(while: { $0 <= 1000 }).count) ludic numbers <= 1000")
print("Ludic numbers 2000...2005: \(Array(ludicNumbers.dropFirst(1998).prefix(7)))")

let triples = ludicNumbers.lazy
  .prefix(while: { $0 <= 250 })
  .filter({ Set(ludicNumbers).contains($0 + 2) && Set(ludicNumbers).contains($0 + 6) })
  .map({ ($0, $0 + 2, $0 + 6) })

print("Ludic triples < 250 = \(Array(triples))")
