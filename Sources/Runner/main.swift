import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let testCases = [
  "037833100",
  "17275R102",
  "38259P508",
  "594918104",
  "68389X106",
  "68389X105"
]

for potentialCUSIP in testCases {
  print("\(potentialCUSIP) -> ", terminator: "")

  switch CUSIP(value: potentialCUSIP) {
  case nil:
    print("Invalid")
  case _:
    print("Valid")
  }
}

