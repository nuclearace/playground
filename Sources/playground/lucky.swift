//
// Created by Erik Little on 2018-10-21.
//

import Foundation

public struct LuckyNumbers : Sequence, IteratorProtocol {
  public let even: Bool
  public let through: Int

  private var drainI = 0
  private var n = 0
  private var lst: [Int]

  public init(even: Bool = false, through: Int = 1_000_000) {
    self.even = even
    self.through = through
    self.lst = Array(stride(from: even ? 2 : 1, through: through, by: 2))
  }

  public mutating func next() -> Int? {
    guard n != 0 else {
      defer { n += 1 }

      return lst[0]
    }

    while n < lst.count && lst[n] < lst.count {
      let retVal = lst[n]

      lst = lst.enumerated().filter({ ($0.offset + 1) % lst[n] != 0  }).map({ $0.element })
      n += 1

      return retVal
    }

    if drainI == 0 {
      lst = Array(lst.dropFirst(n))
    }

    while drainI < lst.count {
      defer { drainI += 1 }

      return lst[drainI]
    }

    return nil
  }
}

private func evenString(_ even: Bool) -> String {
  return even ? "even" : ""
}

public func jLuckyNumber(_ j: Int, even: Bool) {
  print("The \(j)th \(evenString(even)) lucky number is \(Array(LuckyNumbers(even: even))[j-1..<j].first!)")
}

public func luckyNumbersKth(j: Int, k: Int, even: Bool) {
  print("List of \(j) ... \(k) \(evenString(even)) lucky numbers: ", terminator: "")

  for (offset, luck) in LuckyNumbers(even: even).lazy.enumerated() {
    guard offset + 1 <= k else { break }

    if offset + 1 >= j {
      print(luck, terminator: ", ")
    }
  }

  print()
}

public func luckyNumbersRange(j: Int, k: Int, even: Bool) {
  print("List of \(evenString(even)) lucky numbers in the range \(j) ... \(-k): ", terminator: "")

  for lucky in LuckyNumbers(even: even).lazy {
    guard lucky <= -k else { break }

    if lucky >= j {
      print(lucky, terminator: ", ")
    }
  }

  print()
}

public func runLucky() {
  let args = Array(CommandLine.arguments.dropFirst())

  guard let sj = args.first, let j = Int(sj), j > 0, j <= 10_000 else {
    fatalError("Incorrect j")
  }

  switch args.count {
  case 1:
    jLuckyNumber(j, even: false)
  case 2:
    switch Int(args.last!) {
    case let k? where k > 0 && k <= 10_000 && k > j:
      luckyNumbersKth(j: j, k: k, even: false)
    case let k? where k < 0 && -k > j:
      luckyNumbersRange(j: j, k: k, even: false)
    case _:
      fatalError("Bad args")
    }
  case 3:
    switch (Int(args[1]), args.last!) {
    case (nil, "lucky"):
      jLuckyNumber(j, even: false)
    case (nil, "evenLucky"):
      jLuckyNumber(j, even: true)
    case let (k?, "lucky") where k > 0 && k <= 10_000 && k > j:
      luckyNumbersKth(j: j, k: k, even: false)
    case let (k?, "evenLucky") where k > 0 && k <= 10_000 && k > j:
      luckyNumbersKth(j: j, k: k, even: true)
    case let (k?, "lucky") where k < 0 && -k > j:
      luckyNumbersRange(j: j, k: k, even: false)
    case let (k?, "evenLucky") where k < 0 && -k > j:
      luckyNumbersRange(j: j, k: k, even: true)
    case _:
      fatalError("Bad args")
    }
  case _:
    fatalError()
  }
}
