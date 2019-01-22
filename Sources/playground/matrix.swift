//
// Created by Erik Little on 2018-12-06.
//

public func identityMatrix(size: Int) -> [[Int]] {
  return (0..<size).map({i in
    return (0..<size).map({ $0 == i ? 1 : 0 })
  })
}
