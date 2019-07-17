//
// Created by Erik Little on 2019-06-24.
//

import Foundation

public final class AtomicBuckets: CustomStringConvertible {
  public var count: Int {
    return buckets.count
  }

  public var description: String {
    return withBucketsLocked { "\(buckets); TC: \(transferCount)" }
  }

  public var total: Int {
    return withBucketsLocked { buckets.reduce(0, +) }
  }

  private let lock = DispatchSemaphore(value: 1)

  private var buckets: [Int]
  private var transferCount = 0

  public subscript(n: Int) -> Int {
    return withBucketsLocked { buckets[n] }
  }

  public init(with buckets: [Int]) {
    self.buckets = buckets
  }

  public func transfer(amount: Int, from: Int, to: Int) {
    withBucketsLocked {
      let transferAmount = buckets[from] >= amount ? amount : buckets[from]

      buckets[from] -= transferAmount
      buckets[to] += transferAmount
      transferCount &+= 1
    }
  }

  private func withBucketsLocked<T>(do: () -> T) -> T {
    let ret: T

    lock.wait()
    ret = `do`()
    lock.signal()

    return ret
  }
}
