//
// Created by Erik Little on 2019-04-22.
//

import Foundation

public final class PigTheDice {
  public private(set) var p1Score = 0
  public private(set) var p2Score = 0

  public init() { }

  public func play() {
    for player in [CurrentPlayer.one, .two].cycled() {
      print("\(player)'s Turn. Current score \(self[keyPath: player.pathToScore]). Roll?")

      var runningScore = 0

      while let roll = readLine(strippingNewline: true)?.lowercased(), roll == "y" {
        let rolled = Int.random(in: 1...6)

        print("Rolled \(rolled)")

        switch rolled {
        case 1:
          print("Rolled 1, running score lost")
          runningScore = 0
          break
        case _:
          runningScore += rolled
        }

        if self[keyPath: player.pathToScore] + runningScore == 100 {
          print("\(self[keyPath: player.pathToScore]) wins!")
          exit(0)
        }

        print("""
              \(player)'s Turn. Current score \(self[keyPath: player.pathToScore])
               Running score: \(runningScore). Roll?
              """)
      }

      switch player {
      case .one:
        p1Score += runningScore
      case .two:
        p2Score += runningScore
      }
    }
  }

  enum CurrentPlayer: CustomStringConvertible {
    case one, two

    var description: String {
      return "Player \(self == .one ? "One" : "Two")"
    }

    var pathToScore: WritableKeyPath<PigTheDice, Int> {
      switch self {
      case .one:
        return \p1Score
      case .two:
        return \p2Score
      }
    }
  }
}
