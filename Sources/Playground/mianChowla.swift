//
// Created by Erik Little on 10/21/19.
//

import Foundation

public func mianChowla(n: Int) -> [Int] {
  var mc = Array(repeating: 0, count: n)
  var ls = [2: true]
  var lsx = [Int]()

  lsx.reserveCapacity(n)
  ls.reserveCapacity(n*(n+1)/2)

  mc[0] = 1

  for i in 1..<n {
    lsx.removeAll(keepingCapacity: true)

    jLoop: for j in (mc[i-1]+1)... {
      mc[i] = j

      for k in 0...i {
        let sum = mc[k] + j

        if ls[sum] ?? false {
          lsx.removeAll(keepingCapacity: true)
          continue jLoop
        }

        lsx.append(sum)
      }

      for n in lsx {
        ls[n] = true
      }

      break
    }
  }

  return mc
}

public struct MianChowla: Sequence, IteratorProtocol {
  private var mc = [1]
  private var ls = [2: true]
  private var lsx = [Int]()
  private var i = 0

  public init() {}

  public mutating func next() -> Int? {
    defer {
      i += 1
    }

    guard i != 0 else {
      return 1
    }

    if mc.count == i {
      mc.append(0)
    }

    lsx.removeAll(keepingCapacity: true)

    jLoop: for j in (mc[i-1]+1)... {
      mc[i] = j

      for k in 0...i {
        let sum = mc[k] + j

        if ls[sum] ?? false {
          lsx.removeAll(keepingCapacity: true)
          continue jLoop
        }

        lsx.append(sum)
      }

      for n in lsx {
        ls[n] = true
      }

      return mc.last
    }

    return nil
  }
}
