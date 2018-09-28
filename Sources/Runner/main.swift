import BigInt
import CStuff
import Foundation
import Playground

let res1 = cholesky(
  matrix: [25.0, 15.0, -5.0,
           15.0, 18.0,  0.0,
           -5.0,  0.0, 11.0],
  n: 3
)

let res2 = cholesky(
  matrix: [18.0, 22.0,  54.0,  42.0,
           22.0, 70.0,  86.0,  62.0,
           54.0, 86.0, 174.0, 134.0,
           42.0, 62.0, 134.0, 106.0],
  n: 4
)

printMatrix(res1, n: 3)
print()
printMatrix(res2, n: 4)
