import BigInt
import CStuff
import Foundation
import Playground

var switchResults = [Bool]()

for _ in 0..<100_000 {
  let guess = Int.random(in: 1...3)
  let wasRight = montyHall(guess: guess, switch: true)

  switchResults.append(wasRight)
}

let switchWins = switchResults.filter({ $0 }).count

print("Switching would've won \((Double(switchWins) / Double(switchResults.count)) * 100)% of games")
print("Not switching would've won \(((Double(switchResults.count - switchWins)) / Double(switchResults.count)) * 100)% of games")
