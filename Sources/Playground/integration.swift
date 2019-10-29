//
// Created by Erik Little on 2018-09-26.
//

import Foundation

public enum IntegrationType: CaseIterable {
  case rectangularLeft
  case rectangularRight
  case rectangularMidpoint
  case trapezium
  case simpson
}

public func integrate(
  from: Double,
  to: Double,
  n: Int,
  using: IntegrationType = .simpson,
  f: (Double) -> Double
) -> Double {
  let integrationFunc: (Double, Double, Int, (Double) -> Double) -> Double

  switch using {
  case .rectangularLeft:
    integrationFunc = integrateRectL
  case .rectangularRight:
    integrationFunc = integrateRectR
  case .rectangularMidpoint:
    integrationFunc = integrateRectMid
  case .trapezium:
    integrationFunc = integrateTrapezium
  case .simpson:
    integrationFunc = integrateSimpson
  }

  return integrationFunc(from, to, n, f)
}

private func integrateRectL(from: Double, to: Double, n: Int, f: (Double) -> Double) -> Double {
  let h = (to - from) / Double(n)
  var x = from
  var sum = 0.0

  while x <= to - h {
    sum += f(x)
    x += h
  }

  return h * sum
}

private func integrateRectR(from: Double, to: Double, n: Int, f: (Double) -> Double) -> Double {
  let h = (to - from) / Double(n)
  var x = from
  var sum = 0.0

  while x <= to - h {
    sum += f(x + h)
    x += h
  }

  return h * sum
}

private func integrateRectMid(from: Double, to: Double, n: Int, f: (Double) -> Double) -> Double {
  let h = (to - from) / Double(n)
  var x = from
  var sum = 0.0

  while x <= to - h {
    sum += f(x + h / 2.0)
    x += h
  }

  return h * sum
}

private func integrateTrapezium(from: Double, to: Double, n: Int, f: (Double) -> Double) -> Double {
  let h = (to - from) / Double(n)
  var sum = f(from) + f(to)

  for i in 1..<n {
    sum += 2 * f(from + Double(i) * h)
  }

  return h * sum / 2
}

private func integrateSimpson(from: Double, to: Double, n: Int, f: (Double) -> Double) -> Double {
  let h = (to - from) / Double(n)
  var sum1 = 0.0
  var sum2 = 0.0

  for i in 0..<n {
    sum1 += f(from + h * Double(i) + h / 2.0)
  }

  for i in 1..<n {
    sum2 += f(from + h * Double(i))
  }

  return h / 6.0 * (f(from) + f(to) + 4.0 * sum1 + 2.0 * sum2)
}
