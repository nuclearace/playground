import ArgumentParser
//import AsyncHTTPClient
import BigInt
//import BigNumber
import ClockTimer
// import CGMP
import CStuff
import Foundation
import Playground
import Numerics

let (matches, matchedSeps) = "a!===b=!=c".multiSplit(on: ["==", "!=", "="])

print(matches, matchedSeps.map({ $0.0 }))
