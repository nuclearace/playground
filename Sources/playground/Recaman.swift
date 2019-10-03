//
// Created by Erik Little on 9/30/19.
//

import Foundation


//private let firstThousand = Set(0...1000)
//
//private var seen = Set<Int>()
//private var firstDup = false
//
//print("First 15 in sequence: \(Array(Recaman().prefix(15)))")
//
//for (i, n) in Recaman().enumerated() {
//  if !firstDup && seen.contains(n) {
//    print("First duplicate \(i): \(n)")
//
//    firstDup = true
//  }
//
//  seen.insert(n)
//
//  if firstThousand.subtracting(seen).isEmpty {
//    print("All numbers in range 0...1000 are covered by n = \(i)")
//
//    break
//  }
//}

public struct Recaman: Sequence, IteratorProtocol {
  private var found = Set<Int>()
  private var n = 0
  private var nxt = 0

  public init() {}

  public mutating func next() -> Int? {
    guard !found.isEmpty else {
      found.insert(0)

      return 0
    }

    let an1 = nxt

    n += 1
    nxt = an1 - n

    if nxt < 0 || found.contains(nxt) {
      nxt = an1 + n
    }

    found.insert(nxt)

    return nxt
  }
}
