import ArgumentParser
//import AsyncHTTPClient
import BigInt
import ClockTimer
// import CGMP
import CStuff
import Foundation
import Playground
import Numerics

func f<T: Ring>(_ x: T) -> T { (x ** 100) + x + x.one }

let x = ModInt(10, modulo: 13)
let y = f(x)

print("x ^ 100 + x + 1 for x = ModInt(10, 13) is \(y)")
