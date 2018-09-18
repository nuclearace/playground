//
// Created by Erik Little on 9/9/18.
//

public func populationNext(lambda: Double, initial: Double) -> Double {
  return lambda * initial * (1 - initial)
}
