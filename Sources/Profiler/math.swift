//
// Created by Erik Little on 2018-10-08.
//

import Foundation

func stdDev(samples: [Double]) -> Double {
  let mean = samples.reduce(0, +) / Double(samples.count)

  return (samples.map({ pow(($0 - mean), 2) }).reduce(0, +) / (Double(samples.count - 1))).squareRoot()
}
