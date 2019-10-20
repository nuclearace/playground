import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

//let longPi = "3." + DigitsOfPi().prefix(100).dropFirst().lazy.map({ String($0) }).joined()
//
//guard let bigPi = BigDecimal(longPi) else {
//  fatalError()
//}
//
//print(bigPi * 0.1)
//
//let a = BigDecimal(1)
//let b = BigDecimal(998001)
//let c = BigDecimal("-0.00001")!
////let d = bigPi / BigDecimal("0.0005")!
////
////print(BigDecimal("3.14159")!.power(-3))
//print(a / b)

let (position, speed) = orbitalStateVectors(
  semimajorAxis: 1.0,
  eccentricity: 0.1,
  inclination: 0.0,
  longitudeOfAscendingNode: 355.0 / (113.0 * 6.0),
  argumentOfPeriapsis: 0.0,
  trueAnomaly: 0.0
)

print("Position: \(position); Speed: \(speed)")
