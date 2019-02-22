//
// Created by Erik Little on 2018-12-06.
//

import Foundation

public func identityMatrix(size: Int) -> [[Int]] {
  return (0..<size).map({i in
    return (0..<size).map({ $0 == i ? 1 : 0 })
  })
}

public func gaussPartial(a0: [[Double]], b0: [Double]) -> [Double] {
  let m = b0.count
  var a = [[Double]](repeating: [Double](repeating: 0.0, count: m), count: m)

  for (i, var ai) in a0.enumerated() {
    ai.append(b0[i])
    a[i] = ai
  }

  for k in 0..<a.count {
    var iMax = 0
    var max = -1.0

    for i in k..<m {
      let row = a[i]

      var scale = -1.0

      for j in k..<m {
        let e = abs(row[j])

        if e > scale {
          scale = e
        }
      }

      let abso = abs(row[k]) / scale

      if abso > max {
        iMax = i
        max = abso
      }
    }

    if a[iMax][k] == 0.0 {
      fatalError("Matrix is singular")
    }

    a.swapAt(k, iMax)

    for i in k+1..<m {
      for j in k+1...m {
        a[i][j] -= a[k][j] * a[i][k] / a[k][k]
      }

      a[i][k] = 0.0
    }
  }
  
  var ret = [Double](repeating: 0.0, count: m)
  
  for i in stride(from: m - 1, through: 0, by: -1) {
    ret[i] = a[i][m]
    
    for j in i+1..<m {
      ret[i] -= a[i][j] * ret[j]
    }

    ret[i] /= a[i][i]
  }

  return ret
}
