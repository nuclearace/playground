//
// Created by Erik Little on 2019-06-19.
//

import Foundation

public func evolve(
  to target: String,
  parent: inout String,
  mutationRate: Int,
  copies: Int
) {
  var parentFitness: Int {
    return fitness(target: target, sentence: parent)
  }

  var generation = 0

  while parent != target {
    generation += 1

    let bestOfGeneration =
        (0..<copies)
          .map({_ in mutated(sentence: parent, rate: mutationRate) })
          .map({ (fitness(target: target, sentence: $0), $0) })
          .sorted(by: { $0.0 < $1.0 })
          .first!

    if bestOfGeneration.0 < parentFitness {
      print("Gen \(generation) produced better fit. \(bestOfGeneration.1) with fitness \(bestOfGeneration.0)")
      parent = bestOfGeneration.1
    }
  }
}

public func fitness(target: String, sentence: String) -> Int {
  return zip(target, sentence).filter(!=).count
}

public func mutated(sentence: String, rate: Int) -> String {
  return String(
    sentence.map({char in
      if Int.random(in: 1...100) - rate <= 0 {
        return "ABCDEFGHIJKLMNOPQRSTUVWXYZ ".randomElement()!
      } else {
        return char
      }
    })
  )
}

