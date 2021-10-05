//
// Created by Erik Little on 10/5/21.
//

import Foundation

extension String {
  public func isEsthetic(base: Int = 10) -> Bool {
    zip(dropFirst(0), dropFirst())
      .lazy
      .allSatisfy({ abs(Int(String($0.0), radix: base)! - Int(String($0.1), radix: base)!) == 1 })
  }
}

public func getEsthetics(from: Int, to: Int, base: Int = 10) -> [String] {
  guard base >= 2, to >= from else {
    return []
  }

  var start = ""
  var end = ""

  repeat {
    if start.count & 1 == 1 {
      start += "0"
    } else {
      start += "1"
    }
  } while Int(start, radix: base)! < from

  let digiMax = String(base - 1, radix: base)
  let lessThanDigiMax = String(base - 2, radix: base)
  var count = 0

  repeat {
    if count != base - 1 {
      end += String(count + 1, radix: base)
      count += 1
    } else {
      if String(end.last!) == digiMax {
        end += lessThanDigiMax
      } else {
        end += digiMax
      }
    }
  } while Int(end, radix: base)! < to

  if Int(start, radix: base)! >= Int(end, radix: base)! {
    return []
  }

  var esthetics = [Int]()

  func shimmer(_ n: Int, _ m: Int, _ i: Int) {
    if (n...m).contains(i) {
      esthetics.append(i)
    } else if i == 0 || i > m {
      return
    }

    let d = i % base
    let i1 = i &* base &+ d &- 1
    let i2 = i1 &+ 2

    if (i1 < i || i2 < i) {
      // overflow
      return
    }

    switch d {
    case 0: shimmer(n, m, i2)
    case base-1: shimmer(n, m, i1)
    case _:
      shimmer(n, m, i1)
      shimmer(n, m, i2)
    }
  }

  for digit in 0..<base {
    shimmer(Int(start, radix: base)!, Int(end, radix: base)!, digit)
  }

  return esthetics.filter({ $0 <= to }).map({ String($0, radix: base) })
}
