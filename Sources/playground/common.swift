//
// Created by Erik Little on 2018-09-28.
//

public enum Either<L, R> {
  case left(L)
  case right(R)
}

@inlinable
public func printMatrix<T>(_ matrix: [T], n: Int) {
  for i in 0..<n {
    for j in 0..<n {
      print(matrix[i * n + j], terminator: " ")
    }

    print()
  }
}

@inlinable
public func replicateAtLeastOnce<T>(_ n: T, times: Int) -> [T] {
  guard times > 0 else { return [n] }

  return [n] + [T](repeating: n, count: times - 1)
}
