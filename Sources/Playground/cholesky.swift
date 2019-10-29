//
// Created by Erik Little on 2018-09-28.
//

public func cholesky(matrix: [Double], n: Int) -> [Double] {
  var res = [Double](repeating: 0, count: matrix.count)

  for i in 0..<n {
    for j in 0..<i+1 {
      var s = 0.0

      for k in 0..<j {
        s += res[i * n + k] * res[j * n + k]
      }

      if i == j {
        res[i * n + j] = (matrix[i * n + i] - s).squareRoot()
      } else {
        res[i * n + j] = (1.0 / res[j * n + j] * (matrix[i * n + j] - s))
      }
    }
  }

  return res
}
