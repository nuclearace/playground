//
// Created by Erik Little on 2019-03-19.
//

import Foundation

public func castOutNines(n: Int) -> Int {
  guard n > 8 else {
    return n
  }

  return castOutNines(n: String(n).map({ Int(String($0))! }).filter({ $0 % 9 != 0 }).reduce(0, +))
}

extension Array {
  public mutating func satalloShuffle() {
    for i in stride(from: index(before: endIndex), through: 1, by: -1) {
      swapAt(i, .random(in: 0..<i))
    }
  }

  public func satalloShuffled() -> [Element] {
    var arr = Array(self)

    arr.satalloShuffle()

    return arr
  }
}

@inlinable
public func + <T>(el: T, arr: [T]) -> [T] {
  var ret = arr

  ret.insert(el, at: 0)

  return ret
}

@inlinable
public func cartesianProduct<T>(_ arrays: [T]...) -> [[T]] {
  guard let head = arrays.first else {
    return []
  }

  let first = Array(head)

  func pel(
    _ el: T,
    _ ll: [[T]],
    _ a: [[T]] = []
  ) -> [[T]] {
    switch ll.count {
    case 0:
      return a.reversed()
    case _:
      let tail = Array(ll.dropFirst())
      let head = ll.first!

      return pel(el, tail, el + head + a)
    }
  }

  return arrays.lazy.reversed()
    .reduce([first], {res, el in el.flatMap({ pel($0, res) }) })
    .map({ $0.dropLast(first.count) })
}

extension Sequence {
  @inlinable
  public func groupedBy<PropertyType: Hashable>(
    _ extractor: (Element) -> PropertyType
  ) -> [PropertyType: [Element]] {
    var dict: [PropertyType: [Element]] = [:]

    for el in self {
      dict[extractor(el), default: []].append(el)
    }

    return dict
  }

  @inlinable
  public func groupedBy<PropertyType: Hashable>(
    _ property: KeyPath<Element, PropertyType>
  ) -> [PropertyType: [Element]] {
    var dict: [PropertyType: [Element]] = [:]

    for el in self {
      dict[el[keyPath: property], default: []].append(el)
    }

    return dict
  }
}

extension Array where Element: Comparable {
  @inlinable
  public func longestIncreasingSubsequence() -> [Element] {
    var startI = [Int](repeating: 0, count: count)
    var endI = [Int](repeating: 0, count: count + 1)
    var len = 0

    for i in 0..<count {
      var lo = 1
      var hi = len

      while lo <= hi {
        let mid = Int(ceil((Double(lo + hi)) / 2))

        if self[endI[mid]] <= self[i] {
          lo = mid + 1
        } else {
          hi = mid - 1
        }
      }

      startI[i] = endI[lo-1]
      endI[lo] = i

      if lo > len {
        len = lo
      }
    }

    var arr = [Element]()
    var k = endI[len]

    for _ in 0..<len {
      arr.append(self[k])
      k = startI[k]
    }

    return arr.reversed()
  }
}
