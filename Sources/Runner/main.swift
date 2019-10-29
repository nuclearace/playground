import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

for candidate in 2..<1<<19 {
  var sum = Frac(numerator: 1, denominator: candidate)

  let m = Int(ceil(Double(candidate).squareRoot()))

  for factor in 2..<m where candidate % factor == 0 {
    sum += Frac(numerator: 1, denominator: factor)
    sum += Frac(numerator: 1, denominator: candidate / factor)
  }

  if sum == 1 {
    print("\(candidate) is perfect")
  }
}
