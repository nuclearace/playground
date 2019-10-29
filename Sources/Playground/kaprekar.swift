//
// Created by Erik Little on 2019-02-27.
//

import Foundation

public func runKaprekar(max: Int, shouldPrint: Bool = false) -> Int {
  var count = 0

  for i in 1...max {
    let (isKaprekar, order) = kaprekar(n: i)

    guard isKaprekar else {
      continue
    }

    count += 1

    if shouldPrint {
      print(i, isKaprekar, order ?? "None")
    }
  }

  return count
}

public func kaprekar(n: Int, base: Int = 10) -> (Bool, Int?) {
  guard n != 1 else {
    return (true, nil)
  }

  let nn = n * n
  var order = 0
  var power = 1

  while power <= nn {
    power *= base
    order += 1
  }

  power /= base
  order -= 1

  while power > 1 {
    let quo = nn / power
    let rem = nn % power

    if quo >= n {
      return (false, nil)
    }

    if quo + rem == n {
      return (true, order)
    }

    power /= base
    order -= 1
  }

  return (false, nil)
}
