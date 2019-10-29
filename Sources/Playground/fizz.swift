//
// Created by Erik Little on 2019-03-27.
//

public struct Factor {
  public var n: Int
  public var string: String

  public init(n: Int, string: String) {
    self.n = n
    self.string = string
  }
}

public enum FizzBuzzResult {
  case n(Int)
  case fizzed(String)
}

public func fizz(max: Int, fac1: Factor, fac2: Factor, fac3: Factor) -> [FizzBuzzResult] {
  return (1...max).map({n in
    let multiples = [fac1, fac2, fac3].map({ n.isMultiple(of: $0.n) ? FizzBuzzResult.fizzed($0.string) : .n(n) })

    return multiples.reduce(.n(n), {cur, res in
      switch (cur, res) {
      case (_, .n):
        return cur
      case let (.fizzed(str), .fizzed(str2)):
        return .fizzed(str + str2)
      case (.n, .fizzed):
        return res
      }
    })
  })
}

