import BigInt
import CStuff
import Foundation
import Playground
import Numerics

struct DigitTime {
  var hour: Int
  var minute: Int
  var second: Int

  init?(fromString str: String) {
    let split = str.components(separatedBy: ":").compactMap(Int.init)

    guard split.count == 3 else {
      return nil
    }

    (hour, minute, second) = (split[0], split[1], split[2])
  }

  init(fromDegrees angle: Double) {
    let totalSeconds = 24 * 60 * 60 * angle / 360

    second = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
    minute = Int((totalSeconds.truncatingRemainder(dividingBy: 3600) - Double(second)) / 60)
    hour = Int(totalSeconds / 3600)
  }

  func toDegrees() -> Double {
    return 360 * Double(hour) / 24.0 + 360 * Double(minute) / (24 * 60.0) + 360 * Double(second) / (24 * 3600.0)
  }
}

extension DigitTime: CustomStringConvertible {
  var description: String { String(format: "%02i:%02i:%02i", hour, minute, second) }
}

let times = ["23:00:17", "23:40:20", "00:12:45", "00:17:19"].compactMap(DigitTime.init(fromString:))

guard times.count == 4 else {
  fatalError()
}

let meanTime = DigitTime(fromDegrees: 360 + meanOfAngles(times.map({ $0.toDegrees() })))

print("Given times \(times), the mean time is \(meanTime)")
