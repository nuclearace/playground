//
// Created by Erik Little on 9/3/18.
//

import Foundation

public struct TimeResult {
  public var seconds: Double
  public var nanoSeconds: Double

  public var duration: Double { seconds + (nanoSeconds / 1e9) }

  @usableFromInline
  init(seconds: Double, nanoSeconds: Double) {
    self.seconds = seconds
    self.nanoSeconds = nanoSeconds
  }
}

extension TimeResult: CustomStringConvertible {
  public var description: String {
    return "TimeResult(seconds: \(seconds); nanoSeconds: \(nanoSeconds); duration: \(duration)s)"
  }
}

public struct ClockTimer {
  @inlinable @inline(__always)
  public static func time<T>(_ f: () throws -> T) rethrows -> (T, TimeResult) {
    var tsi = timespec()
    var tsf = timespec()

    clock_gettime(CLOCK_MONOTONIC_RAW, &tsi)
    let res = try f()
    clock_gettime(CLOCK_MONOTONIC_RAW, &tsf)

    let secondsElapsed = difftime(tsf.tv_sec, tsi.tv_sec)
    let nanoSecondsElapsed = Double(tsf.tv_nsec - tsi.tv_nsec)

    return (res, TimeResult(seconds: secondsElapsed, nanoSeconds: nanoSecondsElapsed))
  }
}
