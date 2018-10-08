//
// Created by Erik Little on 2018-10-08.
//

func stdDev(samples: [Double]) -> Double {
  let mean = samples.reduce(0, +) / Double(samples.count)

  return (samples.map({ ($0 - mean) * ($0 - mean) }).reduce(0, +) / (Double(samples.count - 1))).squareRoot()
}
