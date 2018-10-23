import BigInt
import CStuff
import Foundation
import Playground

var count = 0
var i = 1.0

while count < 25 {
  let start = Int(pow(10, i))
  let end = start * 10

  for num in start...end {
    let fangs = vampire(n: num)

    guard !fangs.isEmpty else { continue }

    count += 1

    print("\(num) is a vampire number with fangs: \(fangs)")

    guard count != 25 else { break }
  }

  i += 2
}

for (vamp, fangs) in [16758243290880, 24959017348650, 14593825548650].lazy.map({ ($0, vampire(n: $0)) }) {
  if fangs.isEmpty {
    print("\(vamp) is not a vampire number")
  } else {
    print("\(vamp) is a vampire number with fangs: \(fangs)")
  }
}
