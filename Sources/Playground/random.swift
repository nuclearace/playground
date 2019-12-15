//
// Created by Erik Little on 9/3/18.
//

import Foundation

public struct MTRandom: RandomNumberGenerator {
  private var index = 312
  private var mt = [UInt64](repeating: 0, count: 312)

  public init(seed: UInt64 = .random(in: .min ... .max)) {
    mt[0] = seed

    for i in 1..<312 {
      mt[i] = 6364136223846793005 &* (mt[i - 1] ^ (mt[i - 1] >> 62)) + UInt64(i)
    }
  }

  public mutating func next() -> UInt64 {
    if index >= 312 {
      twist()
    }

    var y = mt[index]

    y ^= y >> 29 & 0x5555555555555555
    y ^= y << 17 & 0x71D67FFFEDA60000
    y ^= y << 37 & 0xFFF7EEE000000000
    y ^= y >> 1

    index += 1

    return y
  }

  private mutating func twist() {
    index = 0

    for i in 0..<312 {
      let y = (mt[i] & 0x7FFFFFFF) + (mt[(i + 1) % 312] & ~0x7FFFFFFF)

      mt[i] = mt[(i + 156) % 312] ^ y >> 1

      if y % 2 != 0 {
        mt[i] ^= 0xB5026F5AA96619E9
      }
    }
  }
}

public func generateRandomNumArray(numDigits: Int = 4) -> [Int] {
  guard numDigits > 0 else {
    return []
  }

  let needed =  min(9, numDigits)
  var nums = Set<Int>()

  repeat {
    nums.insert(.random(in: 1...9))
  } while nums.count != needed

  return Array(nums)
}

extension BinaryInteger {
  @inlinable
  public static func randomInt(withMaximumWidth width: Int) -> Self {
    guard width > 0 else {
      return 0
    }

    var res = Self(0)

    for i in 0..<width {
      res |= (Bool.random() ? 1 : 0) << i
    }

    return res
  }

  @inlinable
  public static func randomInt(lessThan max: Self) -> Self {
    guard let width = max.highestSetBitPosition else {
      return 0
    }

    var random: Self

    repeat {
      random = randomInt(withMaximumWidth: width + 1)
    } while random >= max

    return random
  }
}
