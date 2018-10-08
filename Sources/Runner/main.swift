import BigInt
import CStuff
import Foundation
import Playground

for diff in (0...9).map({ nthForwardsDifference(of: [90, 47, 58, 29, 22, 32, 55, 5, 55, 73], n: $0) }) {
  print(diff)
}
