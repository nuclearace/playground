//
// Created by Erik Little on 2019-07-16.
//

extension Sequence {
  @inlinable
  public func sorted<Value>(
    on: KeyPath<Element, Value>,
    using: (Value, Value) -> Bool
  ) -> [Element] where Value: Comparable {
    return withoutActuallyEscaping(using, do: {using -> [Element] in
      return self.sorted(by: { using($0[keyPath: on], $1[keyPath: on]) })
    })
  }
}

extension Collection where Element: Comparable {
  @inlinable
  public func cocktailSorted() -> [Element] {
    var swapped = false
    var ret = Array(self)

    guard count > 1 else {
      return ret
    }

    repeat {
      for i in 0...ret.count-2 where ret[i] > ret[i + 1] {
        (ret[i], ret[i + 1]) = (ret[i + 1], ret[i])
        swapped = true
      }

      guard swapped else {
        break
      }

      swapped = false

      for i in stride(from: ret.count - 2, through: 0, by: -1) where ret[i] > ret[i + 1] {
        (ret[i], ret[i + 1]) = (ret[i + 1], ret[i])
        swapped = true
      }
    } while swapped

    return ret
  }

  @inlinable
  public func quicksorted() -> [Element] {
    var ret = Array(self)

    guard count > 1 else {
      return ret
    }

    Self.quicksort(&ret[...], lo: ret.startIndex, hi: ret.index(before: ret.endIndex))

    return ret
  }

  @usableFromInline
  static func quicksort(
    _ arr: inout ArraySlice<Element>,
    lo: ArraySlice<Element>.Index,
    hi: ArraySlice<Element>.Index
  ) {
    guard lo < hi else {
      return
    }

    let p = qSortPartition(&arr, lo: lo, hi: hi)

    quicksort(&arr, lo: lo, hi: arr.index(before: p))
    quicksort(&arr, lo: arr.index(after: p), hi: hi)
  }

  @usableFromInline
  static func qSortPartition(
    _ arr: inout ArraySlice<Element>,
    lo: ArraySlice<Element>.Index,
    hi: ArraySlice<Element>.Index
  ) -> ArraySlice<Element>.Index {
    let pivot = arr[hi]
    var i = lo

    for j in lo..<hi where arr[j] < pivot {
      (arr[i], arr[j]) = (arr[j], arr[i])
      i = arr.index(after: i)
    }

    (arr[i], arr[hi]) = (arr[hi], arr[i])

    return i
  }
}
