//
// Created by Erik Little on 9/9/18.
//

public func populationNext(lambda: Double, initial: Double) -> Double {
  return lambda * initial * (1 - initial)
}

// A different kind of population
public func populationCount<T: BinaryInteger>(n: T) -> Int {
  var c = 0
  var n = n

  while n > 0 {
    if n & 1 == 1 {
      c &+= 1
    }

    n >>= 1
  }

  return c
}
