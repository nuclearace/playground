//
// Created by Erik Little on 9/9/18.
//

public func populationNext(lambda: Double, initial: Double) -> Double {
  return lambda * initial * (1 - initial)
}

// A different kind of population
public func populationCount(n: Int) -> Int {
  guard n >= 0 else { fatalError() }

  return String(n, radix: 2).filter({ $0 == "1" }).count
}
