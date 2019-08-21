//
// Created by Erik Little on 9/1/18.
//

@inlinable
public func factorial<T: BinaryInteger>(_ n: T) -> T {
  guard n != 0 else {
    return 1
  }

  return stride(from: n, to: 0, by: -1).reduce(1, *)
}

@inlinable
public func multiFactorial<T: BinaryInteger>(_ n: T, k: T.Stride) -> T {
  return stride(from: n, to: 0, by: -k).reduce(1, *)
}
