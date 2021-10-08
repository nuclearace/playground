import ArgumentParser
//import AsyncHTTPClient
import BigInt
//import BigNumber
import ClockTimer
// import CGMP
import CStuff
import Foundation
import Playground
import Numerics

for (divs, subs) in [([2, 3], [1]), ([2, 3], [2])] {
  print("\nMINIMUM STEPS TO 1:")
  print("  Possible divisors:  \(divs)")
  print("  Possible decrements: \(subs)")

  let (table, hows) = minToOne(divs: divs, subs: subs, upTo: 10)

  for n in 1...10 {
    print("    mintab(  \(n)) in {  \(table[n])} by: ", hows[n].joined(separator: ", "))
  }

  for upTo in [2_000, 50_000] {
    print("\n    Those numbers up to \(upTo) that take the maximum, \"minimal steps down to 1\":")
    let (table, _) = minToOne(divs: divs, subs: subs, upTo: upTo)
    let max = table.dropFirst().max()!
    let maxNs = table.enumerated().filter({ $0.element == max })

    print(
      "      Taking", max, "steps are the \(maxNs.count) numbers:",
      maxNs.map({ String($0.offset) }).joined(separator: ", ")
    )
  }
}
