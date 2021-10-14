//
// Created by Erik Little on 2019-03-22.
//

import BigInt

extension Array {
  @inlinable
  public func combinations(_ k: Int) -> [[Element]] {
    return Self._combinations(slice: self[startIndex...], k)
  }

  @usableFromInline
  static func _combinations(slice: Self.SubSequence, _ k: Int) -> [[Element]] {
    guard k != 1 else {
      return slice.map({ [$0] })
    }

    guard k != slice.count else {
      return [slice.map({ $0 })]
    }

    let chopped = slice[slice.index(after: slice.startIndex)...]

    var res = _combinations(slice: chopped, k - 1).map({ [[slice.first!], $0].flatMap({ $0 }) })

    res += _combinations(slice: chopped, k)

    return res
  }
}

public func permutations(n: Int, k: Int) -> BigInt {
  let l = n - k + 1

  guard l <= n else {
    return 1
  }

  return (l...n).reduce(BigInt(1), { $0 * BigInt($1) })
}

public func combinations(n: Int, k: Int) -> BigInt {
  let fact: BigInt = {
    guard k > 1 else {
      return 1
    }

    return (2...k).map({ BigInt($0) }).reduce(1, *)
  }()

  return permutations(n: n, k: k) / fact
}

@inlinable
public func binomial<T: BinaryInteger>(_ x: (n: T, k: T)) -> T {
  let nFac = factorial(x.n)
  let kFac = factorial(x.k)

  return nFac / (factorial(x.n - x.k) * kFac)
}
