import BigInt
import CStuff
import Foundation
import Playground
import Numerics

typealias LychrelReduce = (seen: Set<BigInt>, seeds: Set<BigInt>, related: Set<BigInt>)

let iters = BigInt(500)

let (seen, seeds, related): LychrelReduce =
  (1...10_000)
    .map({ BigInt($0) })
    .reduce(into: LychrelReduce(seen: Set(), seeds: Set(), related: Set()), {res, cur in
      guard !res.seen.contains(cur) else {
        res.related.insert(cur)

        return
      }

      var seen = false

      let seq = Lychrel(seed: cur, iterations: iters).prefix(while: { seen = res.seen.contains($0); return !seen })
      let last = seq.last!

      guard !isPalindrome(last) || seen else {
        return
      }

      res.seen.formUnion(seq)

      if seq.count == Int(iters) {
        res.seeds.insert(cur)
      } else {
        res.related.insert(cur)
      }
  })

print("Found \(seeds.count + related.count) Lychrel numbers between 1...10_000 when limited to 500 iterations")
print("Number of Lychrel seeds found: \(seeds.count)")
print("Lychrel seeds found: \(seeds.sorted())")
print("Number of related Lychrel nums found: \(related.count)")
print("Lychrel palindromes found: \(seeds.union(related).filter(isPalindrome).sorted())")
