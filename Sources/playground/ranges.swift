//
// Created by Erik Little on 2019-02-28.
//

import Foundation

public func mapRanges(_ r1: ClosedRange<Double>, _ r2: ClosedRange<Double>, to: Double) -> Double {
  let num = (to - r1.lowerBound) * (r2.upperBound - r2.lowerBound)
  let denom = r1.upperBound - r1.lowerBound

  return r2.lowerBound + num / denom
}
