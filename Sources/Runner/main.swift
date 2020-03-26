import ArgumentParser
import AsyncHTTPClient
import BigInt
import ClockTimer
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

//print((1...20).compactMap(hamming).map(hamString))
//print(hamString(hamming(n: 1691)!))
//print(hamString(hamming(n: 1_000_000)!))
print(hamString(hamming(n: 1_000_000_000)!))
