//
// Created by Erik Little on 10/4/19.
//

import Foundation

public struct Vector {
  public var x = 0.0
  public var y = 0.0
  public var z = 0.0

  public init(x: Double, y: Double, z: Double) {
    (self.x, self.y, self.z) = (x, y, z)
  }

  public init?(array: [Double]) {
    guard array.count == 3 else {
      return nil
    }

    (self.x, self.y, self.z) = (array[0], array[1], array[2])
  }

  public func mod() -> Double {
    (x * x + y * y + z * z).squareRoot()
  }

  public static func + (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(
      x: lhs.x + rhs.x,
      y: lhs.y + rhs.y,
      z: lhs.z + rhs.z
    )
  }

  public static func += (lhs: inout Vector, rhs: Vector) {
    lhs.x += rhs.x
    lhs.y += rhs.y
    lhs.z += rhs.z
  }

  public static func - (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(
      x: lhs.x - rhs.x,
      y: lhs.y - rhs.y,
      z: lhs.z - rhs.z
    )
  }

  public static func * (lhs: Vector, rhs: Double) -> Vector {
    return Vector(
      x: lhs.x * rhs,
      y: lhs.y * rhs,
      z: lhs.z * rhs
    )
  }

  public static func *= (lhs: inout Vector, rhs: Double) {
    lhs.x *= rhs
    lhs.y *= rhs
    lhs.z *= rhs
  }

  public static func / (lhs: Vector, rhs: Double) -> Vector {
    return lhs * (1 / rhs)
  }

  public static func /= (lhs: inout Vector, rhs: Double) {
    lhs = lhs * (1 / rhs)
  }
}

extension Vector {
  public static let origin = Vector(x: 0, y: 0, z: 0)
}

extension Vector: Equatable {
  public static func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
  }
}

extension Vector: CustomStringConvertible {
  public var description: String {
    return String(format: "%.6f\t%.6f\t%.6f", x, y, z)
  }
}

public class NBody {
  public let gravitationalConstant: Double
  public let numBodies: Int
  public let timeSteps: Int

  public private(set) var masses: [Double]
  public private(set) var positions: [Vector]
  public private(set) var velocities: [Vector]
  public private(set) var accelerations: [Vector]

  public init?(file: String) {
    guard let data = try? String(contentsOfFile: file) else {
      return nil
    }

    print("Input file:\n\(data)")

    let lines = data.components(separatedBy: "\n").map({ $0.components(separatedBy: " ") })

    let worldData = lines.first!

    guard worldData.count == 3,
          let gc = Double(worldData[0]),
          let bodies = Int(worldData[1]),
          let timeSteps = Int(worldData[2]) else {
      return nil
    }

    let defaultState = Array(repeating: Vector.origin, count: bodies)

    self.gravitationalConstant = gc
    self.numBodies = bodies
    self.timeSteps = timeSteps
    self.masses = Array(repeating: 0, count: bodies)
    self.positions = defaultState
    self.accelerations = defaultState
    self.velocities = defaultState

    let bodyData = lines.dropFirst().map({ $0.compactMap(Double.init) })

    guard bodyData.count == bodies * 3 else {
      return nil
    }

    for n in 0..<bodies {
      masses[n] = bodyData[0 + n * 3][0]

      guard let position = Vector(array: bodyData[1 + n * 3]),
            let velocity = Vector(array: bodyData[2 + n * 3]) else {
        return nil
      }

      positions[n] = position
      velocities[n] = velocity
    }
  }

  private func computeAccelerations() {
    for i in 0..<numBodies {
      accelerations[i] = .origin

      for j in 0..<numBodies where i != j {
        let t = gravitationalConstant * masses[j] / pow((positions[i] - positions[j]).mod(), 3)
        accelerations[i] += (positions[j] - positions[i]) * t
      }
    }
  }

  private func resolveCollisions() {
    for i in 0..<numBodies {
      for j in 0..<numBodies where positions[i] == positions[j] {
        velocities.swapAt(i, j)
      }
    }
  }

  private func computeVelocities() {
    for i in 0..<numBodies {
      velocities[i] += accelerations[i]
    }
  }

  private func computePositions() {
    for i in 0..<numBodies {
      positions[i] += velocities[i] + accelerations[i] * 0.5
    }
  }

  public func printState() {
    for i in 0..<numBodies {
      print("Body \(i + 1): \(positions[i])  |  \(velocities[i])")
    }
  }

  public func simulate() {
    computeAccelerations()
    computePositions()
    computeVelocities()
    resolveCollisions()
  }
}

private func mulAdd(v1: Vector, x1: Double, v2: Vector, x2: Double) -> Vector {
  return v1 * x1 + v2 * x2
}

private func rotate(_ i: Vector, _ j: Vector, alpha: Double) -> (Vector, Vector) {
  return (
    mulAdd(v1: i, x1: +cos(alpha), v2: j, x2: sin(alpha)),
    mulAdd(v1: i, x1: -sin(alpha), v2: j, x2: cos(alpha))
  )
}

public func orbitalStateVectors(
  semimajorAxis: Double,
  eccentricity: Double,
  inclination: Double,
  longitudeOfAscendingNode: Double,
  argumentOfPeriapsis: Double,
  trueAnomaly: Double
) -> (Vector, Vector) {
  var i = Vector(x: 1.0, y: 0.0, z: 0.0)
  var j = Vector(x: 0.0, y: 1.0, z: 0.0)
  let k = Vector(x: 0.0, y: 0.0, z: 1.0)

  (i, j) = rotate(i, j, alpha: longitudeOfAscendingNode)
  (j, _) = rotate(j, k, alpha: inclination)
  (i, j) = rotate(i, j, alpha: argumentOfPeriapsis)

  let l = eccentricity == 1.0 ? 2.0 : 1.0 - eccentricity * eccentricity
  let c = cos(trueAnomaly)
  let s = sin(trueAnomaly)
  let r = l / (1.0 + eccentricity * c)
  let rPrime = s * r * r / l
  let position = mulAdd(v1: i, x1: c, v2: j, x2: s) * r
  var speed = mulAdd(v1: i, x1: rPrime * c - r * s, v2: j, x2: rPrime * s + r * c)

  speed /= speed.mod()
  speed *= (2.0 / r - 1.0 / semimajorAxis).squareRoot()

  return (position, speed)
}
