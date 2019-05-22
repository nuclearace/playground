//
// Created by Erik Little on 2019-05-17.
//

import Foundation

public struct OID {
  public var val: String {
    didSet {
      _parts = val.components(separatedBy: ".").compactMap(Int.init)
    }
  }

  public var parts: [Int] {
    return _parts
  }

  private var _parts: [Int]

  public init(_ val: String) {
    self.val = val
    self._parts = val.components(separatedBy: ".").compactMap(Int.init)
  }
}

extension OID: CustomStringConvertible {
  public var description: String {
    return val
  }
}

extension OID: Comparable {
  public static func < (lhs: OID, rhs: OID) -> Bool {
    let minSize = min(lhs.parts.count, rhs.parts.count)

    for i in 0..<minSize {
      if lhs.parts[i] < rhs.parts[i] {
        return true
      } else if lhs.parts[i] > rhs.parts[i] {
        return false
      }
    }

    return lhs.parts.count < rhs.parts.count
  }

  public static func == (lhs: OID, rhs: OID) -> Bool {
    return lhs.val == rhs.val
  }
}

