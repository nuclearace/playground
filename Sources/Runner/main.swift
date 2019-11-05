import BigInt
import CStuff
import Foundation
import Playground

let res =
  (1..<62)
    .lazy
    .filter({ $0.isPrime })
    .map(carmichael)
    .filter({ !$0.isEmpty })
    .flatMap({ $0 })

for c in res {
  print(c)
}
