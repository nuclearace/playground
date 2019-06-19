import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let target = "METHINKS IT IS LIKE A WEASEL"
let copies = 100
let mutationRate = 20

var start = mutated(sentence: target, rate: 100)

print("target: \(target)")
print("Gen 0: \(start) with fitness \(fitness(target: target, sentence: start))")

evolve(to: target, parent: &start, mutationRate: mutationRate, copies: 100)
