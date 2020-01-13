//
// Created by Erik Little on 2019-03-22.
//

import BigInt

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
