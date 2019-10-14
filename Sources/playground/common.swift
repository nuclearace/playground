//
// Created by Erik Little on 2018-09-28.
//

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
  var bytes = [UInt32]()

  for scalar in str.unicodeScalars {
    let val = scalar.value

    guard val >= minChar && val <= maxChar else {
      continue
    }

    bytes.append(val)
  }

  return bytes
}
