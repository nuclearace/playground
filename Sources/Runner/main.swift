import BigInt
import CStuff
import Foundation
import Playground
import Numerics

let words = [
  "a",
  "bc",
  "abc",
  "cd",
  "b"
] as Set

let testCases = [
  "abcd",
  "abbc",
  "abcbcd",
  "acdbc",
  "abcdd"
]

for test in testCases {
  print("\(test):")
  print("  \(wordBreak(str: test, dict: words) ?? "did not parse with given words")")
}
