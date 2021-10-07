import ArgumentParser
//import AsyncHTTPClient
import BigInt
import ClockTimer
// import CGMP
import CStuff
import Foundation
import Playground
import Numerics

let (x1, y1) = (100 ± 1.1, 50 ± 1.2)
let (x2, y2) = (200 ± 2.2, 100 ± 2.3)

let d = ((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5

print(d)
