import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

print("Please enter a sentence to evolve", terminator: ": ")

guard let target = readLine(strippingNewline: true)?.uppercased() else {
  exit(0)
}

let copies = 100
let mutationRate = 20

var start = mutated(sentence: target, rate: 100)

print("target: \(target)")
print("Gen 0: \(start) with fitness \(fitness(target: target, sentence: start))")

let (_, t) = ClockTimer.time {
  evolve(to: target, parent: &start, mutationRate: mutationRate, copies: 100)
}

print(t)
