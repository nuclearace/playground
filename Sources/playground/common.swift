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

public func convertToAsciiBytes(
  str: String,
  minChar: UInt8,
  maxChar: UInt8
) -> [UInt8] {
  for scalar in str.unicodeScalars {
    print(scalar)
  }

  var bytes = [UInt8]()

  for char in str {
    guard let asciiVal = char.asciiValue, asciiVal >= minChar && asciiVal <= maxChar else {
      continue
    }

    bytes.append(asciiVal)
  }

  return bytes
}
