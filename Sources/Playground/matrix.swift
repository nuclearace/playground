//
// Created by Erik Little on 2018-12-06.
//

import Foundation

@inlinable
public func validMatrix<T>(_ matrix: [[T]]) -> Bool {
  guard !matrix.isEmpty else {
    return true
  }

  let cols = matrix[0].count

  for row in matrix.dropFirst() where row.count != cols {
    return false
  }

  return true
}

@inlinable
public func printMatrix<T>(_ matrix: [[T]]) {
  guard !matrix.isEmpty else {
    print()

    return
  }

  let rows = matrix.count
  let cols = matrix[0].count

  for i in 0..<rows {
    for j in 0..<cols {
      print(matrix[i][j], terminator: " ")
    }

    print()
  }
}

@inlinable
public func printInlineMatrix<T>(_ matrix: [T], n: Int) {
  for i in 0..<n {
    for j in 0..<n {
      print(matrix[i * n + j], terminator: " ")
    }

    print()
  }
}

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

@inlinable
public func matrixMult<T: Numeric>(_ m1: [[T]], _ m2: [[T]]) -> [[T]] {
  let n = m1[0].count
  let m = m1.count
  let p = m2[0].count

  guard m != 0 else {
    return []
  }

  precondition(n == m2.count)

  var ret = Array(repeating: Array(repeating: T.zero, count: p), count: m)

  for i in 0..<m {
    for j in 0..<p {
      for k in 0..<n {
        ret[i][j] += m1[i][k] * m2[k][j]
      }
    }
  }

  return ret
}

@inlinable
public func matrixTranspose<T>(_ matrix: [[T]]) -> [[T]] {
  guard !matrix.isEmpty else {
    return []
  }

  var ret = Array(repeating: [T](), count: matrix[0].count)

  for row in matrix {
    for j in 0..<row.count {
      ret[j].append(row[j])
    }
  }

  return ret
}

@inlinable
public func rref<T: BinaryInteger>(_ matrix: [[T]]) -> [[T]] {
  guard !matrix.isEmpty else {
    return []
  }

  let rowCount = matrix.count
  let colCount = matrix[0].count
  var res = matrix
  var lead = 0

  for r in 0..<rowCount {
    guard colCount > lead else {
      return res
    }

    var i = r

    while res[i][lead] == 0 {
      i += 1

      guard rowCount == i else {
        continue
      }

      i = r
      lead += 1

      guard colCount != lead else {
        return res
      }
    }

    res.swapAt(i, r)

    if res[r][lead] != 0 {
      let div = res[r][lead]

      for j in 0..<colCount {
        res[r][j] /= div
      }
    }

    for k in 0..<rowCount where k != r {
      let mult = res[k][lead]

      for j in 0..<colCount {
        res[k][j] -= res[r][j] * mult
      }
    }

    lead += 1
  }

  return res
}

@inlinable
public func robbins<T: BinaryInteger>(n: Int) -> T {
  var nums = [Int]()
  var doms = [Int]()

  for k in 0..<n {
    nums.append(3*k + 1)
    doms.append(n + k)
  }

  let num = nums.lazy.map({ T($0) }).map(factorial).reduce(1, *)
  let dom = doms.lazy.map({ T($0) }).map(factorial).reduce(1, *)

  return num / dom
}

@inlinable
public func kronecker<T: Numeric>(m1: [[T]], m2: [[T]]) -> [[T]] {
  let m = m1.count
  let n = m1[0].count
  let p = m2.count
  let q = m2[0].count
  let rtn = m * p
  let ctn = n * q

  var res = Array(repeating: Array(repeating: 0 as T, count: ctn), count: rtn)

  for i in 0..<m {
    for j in 0..<n {
      for k in 0..<p {
        for l in 0..<q {
          res[p * i + k][q * j + l] = m1[i][j] * m2[k][l]
        }
      }
    }
  }

  return res
}
