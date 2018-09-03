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

struct ClockTimer {
  func time<T>(_ f: () throws -> T) rethrows -> (T, TimeResult) {
    let s = clock()
    let res = try f()
    let e = clock() - s

    return (res, TimeResult(clocks: Int(e)))
  }

  static func time<T>(_ f: () throws -> T) rethrows -> (T, TimeResult) {
    return try ClockTimer().time(f)
  }
}
