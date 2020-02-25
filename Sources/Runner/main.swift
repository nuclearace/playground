import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

let numGames = 10_000
let lock = DispatchSemaphore(value: 1)
var done = 0

print("Running \(numGames) games for each strategy")

DispatchQueue.concurrentPerform(iterations: 2) {i in
  let strat = i == 0 ? PrisonersGame.Strategy.random : .optimum
  var numPardoned = 0

  for _ in 0..<numGames {
    let game = PrisonersGame(numPrisoners: 100, strategy: strat)

    if game.play() {
      numPardoned += 1
    }
  }

  print("Probability of pardon with \(strat) strategy: \(Double(numPardoned) / Double(numGames))")

  lock.wait()
  done += 1
  lock.signal()

  if done == 2 {
    exit(0)
  }
}

dispatchMain()
