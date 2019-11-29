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

extension RangeReplaceableCollection where Element: Equatable {
  @inlinable
  public func dropFirstIf(_ thing: @autoclosure () -> Element) -> SubSequence {
    guard let first = self.first else {
      return self[...]
    }

    return first == thing() ? dropFirst() : self[...]
  }
}
