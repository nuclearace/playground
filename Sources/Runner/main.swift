import ArgumentParser
//import AsyncHTTPClient
import BigInt
import ClockTimer
// import CGMP
import CStuff
import Foundation
import Playground
import Numerics

let (positionsV1, time) = ClockTimer.time {() -> Set<String> in
  var positions = Set<String>()

  while positions.count != 960 {
    positions.insert(get960Position())
  }

  return positions
}

print(positionsV1.count, positionsV1.randomElement()!, time.duration)

let (positionsV2, time2) = ClockTimer.time {() -> Set<String> in
  var positions = Set<String>()

  while positions.count != 960 {
    positions.insert(get960PositionV2())
  }

  return positions
}

print(positionsV2.count, positionsV2.randomElement()!, time2.duration)
print(startingFEN(from: positionsV2.randomElement()!))
