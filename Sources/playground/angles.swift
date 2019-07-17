//
// Created by Erik Little on 2019-07-17.
//

import Foundation

public func angleDifference(a1: Double, a2: Double) -> Double {
  let diff = (a2 - a1).truncatingRemainder(dividingBy: 360)

  if diff < -180.0 {
    return 360.0 + diff
  } else if diff > 180.0 {
    return -360.0 + diff
  } else {
    return diff
  }
}
