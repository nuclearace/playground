import BigInt
import CStuff
import Playground

for (offset, element) in (0...9).lazy.map(primorial).enumerated() {
  print("primorial(\(offset)) -> \(element)")
}

for (n, primordialN) in [10, 100, 1_000, 10_000, 100_000].lazy.map({ ($0, primorial(n: $0)) }) {
  print("primorial(\(n)) -> has \(primordialN.description.count) digits")
}
