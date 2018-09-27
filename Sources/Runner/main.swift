import BigInt
import CStuff
import Foundation
import Playground

let types = IntegrationType.allCases

print("f(x) = x^3:", types.map({ integrate(from: 0, to: 1, n: 100, using: $0, f: { pow($0, 3) }) }))
print("f(x) = 1 / x:", types.map({ integrate(from: 1, to: 100, n: 1000, using: $0, f: { 1 / $0 }) }))
print("f(x) = x, 0 -> 5_000:", types.map({ integrate(from: 0, to: 5_000, n: 5_000_000, using: $0, f: { $0 }) }))
print("f(x) = x, 0 -> 6_000:", types.map({ integrate(from: 0, to: 6_000, n: 6_000_000, using: $0, f: { $0 }) }))
