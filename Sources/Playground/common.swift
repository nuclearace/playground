//
// Created by Erik Little on 2018-09-28.
//

infix operator ??= : AssignmentPrecedence

@inlinable
public func ??= <T>(lhs: inout T?, rhs: T?) {
  lhs = lhs ?? rhs
}

public enum Either<L, R> {
  case left(L)
  case right(R)
}

@inlinable
public func replicateAtLeastOnce<T>(_ n: T, times: Int) -> [T] {
  guard times > 0 else { return [n] }

  return [n] + [T](repeating: n, count: times - 1)
}

public func convertToUnicodeScalars(
  str: String,
  minChar: UInt32,
  maxChar: UInt32
) -> [UInt32] {
  var scalars = [UInt32]()

  for scalar in str.unicodeScalars {
    let val = scalar.value

    guard val >= minChar && val <= maxChar else {
      continue
    }

    scalars.append(val)
  }

  return scalars
}

extension Sequence {
  @inlinable
  public func take(_ n: Int) -> [Element] {
    var res = [Element]()

    for el in self {
      guard res.count != n else {
        return res
      }

      res.append(el)
    }

    return res
  }
}

extension RangeReplaceableCollection where Element: Equatable {
  @inlinable
  public func dropFirstIf(_ thing: @autoclosure () -> Element) -> SubSequence {
    guard let first = self.first else {
      return self[...]
    }

    return first == thing() ? dropFirst() : self[...]
  }
}

extension Collection where Element: FloatingPoint {
  @inlinable
  public func rms() -> Element {
    return (lazy.map({ $0 * $0 }).reduce(0, +) / Element(count)).squareRoot()
  }
}

extension Collection where Element: Numeric {
  @inlinable
  public func equilibriumIndexes() -> [Index] {
    guard !isEmpty else {
      return []
    }

    let sumAll = reduce(0, +)
    var ret = [Index]()
    var sumLeft: Element = 0
    var sumRight: Element

    for i in indices {
      sumRight = sumAll - sumLeft - self[i]

      if sumLeft == sumRight {
        ret.append(i)
      }

      sumLeft += self[i]
    }

    return ret
  }
}

extension Double {
  @inline(__always)
  public var radians: Double { self * .pi / 180 }
}

extension Array {
  public mutating func removeRandom() -> Element {
    return remove(at: (0..<count).randomElement()!)
  }
}
