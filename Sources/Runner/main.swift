import BigInt
import CStuff
import Foundation
import Playground

let height = 65
let width = 100

var seed = Set<Cell>()

func resetSeed(_ numSeeds: Int) {
  seed.removeAll()

  while seed.count != numSeeds {
    seed.insert(Cell(x: .random(in: 0..<width), y: .random(in: 0..<height)))
  }
}

func getNumSeeds() -> Int? {
  print("Enter number of seeds, or anything else to stop: ", terminator: "")

  guard let num = readLine(strippingNewline: true) else {
    return nil
  }

  return Int(num)
}

var col: Colony

//col.printColony()

while let numSeeds = getNumSeeds() {
  resetSeed(numSeeds)
  col = Colony(cells: seed, height: height, width: width)
  col.run(iterations: 1000, sim: true)
}
