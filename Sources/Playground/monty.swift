//
// Created by Erik Little on 2018-10-02.
//

import Foundation

/// Runs a monty hall simulation and returns whether or not the choice was correct
public func montyHall(doors: Int = 3, guess: Int, switch: Bool) -> Bool {
  guard doors > 2, guess > 0, guess <= doors else { fatalError() }

  let winningDoor = Int.random(in: 1...doors)

  return winningDoor == guess ? !`switch` : `switch`
}
