//
// Created by Erik Little on 9/1/18.
//

import BigInt

func collatz(_ n: BigInt) -> (series: [BigInt], peak: BigInt) {
  var series = [n]
  var n = n
  var peak = n

  while n != 1 {
    switch n & 1 {
    case 0:
      n /= 2
    case 1:
      n = 3*n + 1
    case _:
      fatalError()
    }

    peak = n > peak ? n : peak

    series.append(n)
  }

  return (series, peak)
}
