//
// Created by Erik Little on 9/3/18.
//

import Foundation

public struct TimeResult {
  public var clocks: Int

  @usableFromInline
  init(clocks: Int) {
    self.clocks = clocks
  }

  public var duration: Double {
    return Double(clocks) / Double(CLOCKS_PER_SEC)
  }
}

extension TimeResult : CustomStringConvertible {
  public var description: String {
    return "TimeResult(clocks: \(clocks), duration: \(duration)s)"
  }
}

public struct ClockTimer {
  public init() { }

  @inlinable
  public func time<T>(_ f: () throws -> T) rethrows -> (T, TimeResult) {
    let s = clock()
    let res = try f()
    let e = clock() - s

    return (res, TimeResult(clocks: Int(e)))
  }

  @inlinable
  public static func time<T>(_ f: () throws -> T) rethrows -> (T, TimeResult) {
    return try ClockTimer().time(f)
  }
}
