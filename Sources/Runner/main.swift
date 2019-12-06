import BigInt
import CStuff
import Foundation
import Playground
import Numerics

let dxs = [
  -0.533,  0.270,  0.859, -0.043, -0.205, -0.127, -0.071,  0.275,
  1.251, -0.231, -0.401,  0.269,  0.491,  0.951,  1.150,  0.001,
  -0.382,  0.161,  0.915,  2.080, -2.337,  0.034, -0.126,  0.014,
  0.709,  0.129, -1.093, -0.483, -1.193,  0.020, -0.051,  0.047,
  -0.095,  0.695,  0.340, -0.182,  0.287,  0.213, -0.423, -0.021,
  -0.134,  1.798,  0.021, -1.099, -0.361,  1.636, -1.134,  1.315,
  0.201,  0.034,  0.097, -0.170,  0.054, -0.553, -0.024, -0.181,
  -0.700, -0.361, -0.789,  0.279, -0.174, -0.009, -0.323, -0.658,
  0.348, -0.528,  0.881,  0.021, -0.853,  0.157,  0.648,  1.774,
  -1.043,  0.051,  0.021,  0.247, -0.310,  0.171,  0.000,  0.106,
  0.024, -0.386,  0.962,  0.765, -0.125, -0.289,  0.521,  0.017,
  0.281, -0.749, -0.149, -2.436, -0.909,  0.394, -0.113, -0.598,
  0.443, -0.521, -0.799,  0.087
]

let dys = [
  0.136,  0.717,  0.459, -0.225,  1.392,  0.385,  0.121, -0.395,
  0.490, -0.682, -0.065,  0.242, -0.288,  0.658,  0.459,  0.000,
  0.426,  0.205, -0.765, -2.188, -0.742, -0.010,  0.089,  0.208,
  0.585,  0.633, -0.444, -0.351, -1.087,  0.199,  0.701,  0.096,
  -0.025, -0.868,  1.051,  0.157,  0.216,  0.162,  0.249, -0.007,
  0.009,  0.508, -0.790,  0.723,  0.881, -0.508,  0.393, -0.226,
  0.710,  0.038, -0.217,  0.831,  0.480,  0.407,  0.447, -0.295,
  1.126,  0.380,  0.549, -0.445, -0.046,  0.428, -0.074,  0.217,
  -0.822,  0.491,  1.347, -0.141,  1.230, -0.044,  0.079,  0.219,
  0.698,  0.275,  0.056,  0.031,  0.421,  0.064,  0.721,  0.104,
  -0.729,  0.650, -1.103,  0.154, -1.720,  0.051, -0.385,  0.477,
  1.537, -0.901,  0.939, -0.411,  0.341, -0.411,  0.106,  0.224,
  -0.947, -1.424, -0.542, -1.032
]

extension Collection where Element: FloatingPoint {
  @inlinable
  public func mean() -> Element {
    return reduce(0, +) / Element(count)
  }

  @inlinable
  public func stdDev() -> Element {
    let m = mean()

    return map({ ($0 - m) * ($0 - m) }).mean().squareRoot()
  }
}

typealias Rule = (Double, Double) -> Double

func funnel(_ arr: [Double], rule: Rule) -> [Double] {
  var x = 0.0
  var res = [Double](repeating: 0, count: arr.count)

  for (i, d) in arr.enumerated() {
    res[i] = x + d
    x = rule(x, d)
  }

  return res
}

func experiment(label: String, rule: Rule) {
  let rxs = funnel(dxs, rule: rule)
  let rys = funnel(dys, rule: rule)

  print("\(label)\t:    x        y")
  print("Mean\t:\(String(format: "%7.4f, %7.4f", rxs.mean(), rys.mean()))")
  print("Std Dev\t:\(String(format: "%7.4f, %7.4f", rxs.stdDev(), rys.stdDev()))")
  print()
}

experiment(label: "Rule 1", rule: {_, _ in 0 })
experiment(label: "Rule 2", rule: {_, dz in -dz })
experiment(label: "Rule 3", rule: {z, dz in -(z + dz) })
experiment(label: "Rule 4", rule: {z, dz in z + dz })
