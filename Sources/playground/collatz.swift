//
// Created by Erik Little on 9/1/18.
//

@inlinable
public func collatz<T: BinaryInteger>(_ n: T) -> (series: [T], peak: T) {
  var series = [n]
  var n = n
  var peak = n

  while n != 1 {
    if n & 1 == 0 {
      n /= 2
    } else {
      n = 3*n + 1
    }

    peak = max(n, peak)

    series.append(n)
  }

  return (series, peak)
}
