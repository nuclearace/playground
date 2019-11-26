//
// Created by Erik Little on 11/25/19.
//

import Foundation

public struct Ludic: Sequence, IteratorProtocol {
  private var list: [Int]
  private var taken = [Int]()
  private var nMax: Int

  public init(nMax: Int = 64) {
    self.nMax = nMax
    self.list = Array(2...nMax)
  }

  public mutating func next() -> Int? {
    guard !taken.isEmpty else {
      taken.append(1)

      return 1
    }

    if list.isEmpty {
      nMax *= 2
      list = Array(2...nMax)
      applyRemovals()
    }

    let n = list.first!

    removeFromList(skip: n)

    taken.append(n)

    return n
  }

  private mutating func applyRemovals() {
    for skip in taken.dropFirst() {
      removeFromList(skip: skip)
    }
  }

  private mutating func removeFromList(skip: Int)  {
    for (removed, i) in stride(from: list.startIndex, to: list.endIndex, by: skip).enumerated() {
      list.remove(at: i - removed)
    }
  }
}

private struct Filter {
  var i: Int
  var v: Int
}

public func ludic(minLength: Int) -> [Int] {
  var cap = 2
  var v = 1
  var active = 1
  var nf = 0

  var f = calloc(cap, MemoryLayout<Filter>.stride).assumingMemoryBound(to: Filter.self)

  f[1].i = 4

  while true {
    defer { v += 1 }

    var i = 1

    while i < active {
      f[i].i -= 1

      guard f[i].i > 0 else {
        break
      }

      i += 1
    }

    if i < active {
      f[i].i = f[i].v
    } else if nf == f[i].i {
      f[i].i = f[i].v
      active += 1
    } else {
      if nf >= cap {
        cap *= 2

        f = realloc(f, MemoryLayout<Filter>.stride * cap).assumingMemoryBound(to: Filter.self)
      }

      f[nf] = Filter(i: v + nf, v: v)
      nf += 1

      guard nf < minLength else {
        break
      }
    }
  }

  var res = [Int]()

  for j in 0..<nf {
    res.append(f[j].v)
  }

  free(f)

  return res
}

