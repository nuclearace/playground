import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let a = Vector(x: 3, y: 4, z: 5)
let b = Vector(x: 4, y: 3, z: 5)
let c = Vector(x: -5, y: -12, z: -13)

print("a: \(a)")
print("b: \(b)")
print("c: \(c)")
print()
print("a • b = \(a • b)")
print("a × b = \(a × b)")
print("a • (b × c) = \(a • (b × c))")
print("a × (b × c) = \(a × (b × c))")
