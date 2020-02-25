//
// Created by Erik Little on 2/24/20.
//

import Foundation

public struct PrisonersGame {
  let strategy: Strategy
  let numPrisoners: Int
  let drawers: [Int]

  public init(numPrisoners: Int, strategy: Strategy) {
    var rng = MTRandom()

    self.numPrisoners = numPrisoners
    self.strategy = strategy
    self.drawers = (1...numPrisoners).shuffled(using: &rng)
  }

  @discardableResult
  public func play() -> Bool {
    for num in 1...numPrisoners {
      guard findNumber(num) else {
        return false
      }
    }

    return true
  }

  private func findNumber(_ num: Int) -> Bool {
    var tries = 0
    var nextDrawer = num - 1

    while tries < 50 {
      tries += 1

      switch strategy {
      case .random where drawers.randomElement()! == num:
        return true
      case .optimum where drawers[nextDrawer] == num:
        return true
      case .optimum:
        nextDrawer = drawers[nextDrawer] - 1
      case _:
        continue
      }
    }

    return false
  }

  public enum Strategy {
    case random, optimum
  }
}
