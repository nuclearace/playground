import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

for i in 0..<100 {
  print("robbins(n: \(i)) = \(robbins(n: i) as BigInt)")
}
