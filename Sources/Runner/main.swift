import BigInt
import CStuff
import Foundation
import Playground
import Numerics

func readableBwt(_ str: String) -> String {
  return str.replacingOccurrences(of: "\u{2}", with: "^").replacingOccurrences(of: "\u{3}", with: "|")
}

let testCases = [
  "banana",
  "appellee",
  "dogwood",
  "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
  "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
  "\u{2}ABC\u{3}"
]

for test in testCases {
  let b = bwt(test) ?? "error"
  let c = ibwt(b) ?? "error"

  print("\(readableBwt(test)) -> \(readableBwt(b)) -> \(readableBwt(c))")
}

