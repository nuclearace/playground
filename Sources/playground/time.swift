//
// Created by Erik Little on 9/3/18.
//

import Foundation

struct TimeResult {
  var clocks: Int

  var duration: Double {
    return Double(clocks) / Double(CLOCKS_PER_SEC)
  }
}

extension TimeResult : CustomStringConvertible {
  var description: String {
    return "TimeResult(clocks: \(clocks), duration: \(duration))"
  }
}

struct ClockTimer {
  @inline(__always)
  func time<T>(_ f: () throws -> T) rethrows -> (T, TimeResult) {
    let s = clock()
    let res = try f()
    let e = clock() - s

    return (res, TimeResult(clocks: Int(e)))
  }

  @inline(__always)
  static func time<T>(_ f: () throws -> T) rethrows -> (T, TimeResult) {
    return try ClockTimer().time(f)
  }
}
