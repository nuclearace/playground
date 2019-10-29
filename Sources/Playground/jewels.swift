//
// Created by Erik Little on 9/17/18.
//

public func countJewels(_ stones: String, _ jewels: String) -> Int {
  return stones.map({ jewels.contains($0) ? 1 : 0 }).reduce(0, +)
}
