import BigInt
import CStuff
import Foundation
import Playground
import Numerics

let coeffs = chebCoeffs(fun: cos, n: 10, min: 0, max: 1)

print("Coefficients")

for coeff in coeffs {
  print(String(format: "%+1.15g", coeff))
}

print("\nApproximations:\n  x      func(x)     approx       diff")

for i in stride(from: 0.0, through: 20, by: 1) {
  let x = mapRange(x: i, min: 0, max: 20, minTo: 0, maxTo: 1)
  let f = cos(x)
  let approx = chebApprox(x: x, n: 10, min: 0, max: 1, coeffs: coeffs)

  print(String(format: "%1.3f  %1.8f  %1.8f  % 4.1e", x, f, approx, approx - f))
}
