//
// Created by Erik Little on 10/12/19.
//

import Foundation

extension BinaryInteger {
  @usableFromInline
  func mPow(_ p: Self, _ m: Self) -> Self {
    var res = Self(1)
    var workingP = p
    var workingSelf = self

    while workingP > 0 {
      if workingP & 1 == 1 {
        res = res * workingSelf % m
      }

      workingSelf = workingSelf * workingSelf % m
      workingP >>= 1
    }

    return res
  }

  @usableFromInline
  func multiplicativeOrderP(_ p: Self, _ e: Int) -> Self {
    let m = p.fastExp(e)
    let t = m / p * (p - 1)
    let factors = t.factors()

    for factor in factors where mPow(factor, m) == 1 {
      return factor
    }

    return 0
  }

  @inlinable
  public func multiplicativeOrder(relativeTo to: Self) -> Self {
    let factors = to.primeDecomposition()
    var res = Self(1)

    let factorsAndExps = factors.lazy.dropFirst().reduce(into: [(factors[0], 1)], {acc, cur in
      if acc.last!.0 != cur {
        acc.append((cur, 1))
      } else {
        acc[acc.index(before: acc.endIndex)].1 += 1
      }
    })

    for (factor, exp) in factorsAndExps {
      res = res.lcm(with: multiplicativeOrderP(factor, exp))
    }

    return res
  }
}
