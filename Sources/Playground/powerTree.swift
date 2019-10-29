//
// Created by Erik Little on 2018-10-01.
//

import BigInt

private var p = [1: 0]
private var lvl = [[1]]

public func treePow(x: Int, n: Int) -> BigInt {
  var r = [0: BigInt(1), 1: BigInt(x)]
  var p = 0

  for i in path(n: n) {
    r[i] = r[i - p]! * r[p]!
    p = i
  }

  return r[n]!
}

private func path(n: Int) -> [Int] {
  guard n != 0 else { return [] }

  while !p.keys.contains(n) {
    var q = [Int]()

    for x in lvl[0] {
      for y in path(n: x) {
        guard !p.keys.contains(x + y) else { break }

        p[x + y] = x
        q.append(x + y)
      }
    }

    lvl[0] = q
  }

  return path(n: p[n]!) + [n]
}
