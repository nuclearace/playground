import BigInt
import ClockTimer
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

func equalBirthdays(nSharers: Int, groupSize: Int, nRepetitions: Int) -> Double {
//  var rng = MTRandom()
  var eq = 0

  for _ in 0..<nRepetitions {
    var group = Array(repeating: 0, count: 365)

    for _ in 0..<groupSize {
      group[Int.random(in: 0..<365)] += 1
    }

    eq += group.contains(where: { $0 >= nSharers }) ? 1 : 0
  }

  return Double(eq) * 100.0 / Double(nRepetitions)
}

var groupEst = 2

for sharers in 2...5 {
  var groupSize = groupEst + 1

  while equalBirthdays(nSharers: sharers, groupSize: groupSize, nRepetitions: 100) < 50 {
    groupSize += 1
  }

  let dGroup = Double(groupSize)
  let inf = Int(dGroup - (dGroup - Double(groupEst)) / 4.0)

  for gs in inf..<groupSize + 999 {
    let eq = equalBirthdays(nSharers: sharers, groupSize: groupSize, nRepetitions: 250)

    if eq > 50 {
      groupSize = gs
      break
    }
  }

  for gs in groupSize - 1 ..< groupSize + 999 {
    let eq = equalBirthdays(nSharers: sharers, groupSize: gs, nRepetitions: 50_000)

    if eq > 50 {
      groupEst = gs

      print("\(sharers) independent people in a group of \(String(format: "%3d", gs))", terminator: "")
      print(" share a common birthday \(String(format: "%2.1f%%", eq))")
      break
    }
  }
}
