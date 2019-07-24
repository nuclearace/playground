import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let testCases = [
  (Point(x: 0.1234, y: 0.9876), Point(x: 0.8765, y: 0.2345), 2.0),
  (Point(x: 0.0000, y: 2.0000), Point(x: 0.0000, y: 0.0000), 1.0),
  (Point(x: 0.1234, y: 0.9876), Point(x: 0.1234, y: 0.9876), 2.0),
  (Point(x: 0.1234, y: 0.9876), Point(x: 0.8765, y: 0.2345), 0.5),
  (Point(x: 0.1234, y: 0.9876), Point(x: 0.1234, y: 0.9876), 0.0)
]

for testCase in testCases {
  switch Circle.circleBetween(testCase.0, testCase.1, withRadius: testCase.2) {
  case nil:
    print("No ans")
  case (let circle1, nil)?:
    print("One ans: \(circle1)")
  case (let circle1, let circle2?)?:
    print("Two ans: \(circle1) \(circle2)")
  }
}
