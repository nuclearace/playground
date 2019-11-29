//
// Created by Erik Little on 11/29/19.
//

private func createString(_ from: String, _ v: [Int?]) -> String {
  var idx = from.count
  var sliceVec = [Substring]()

  while let prev = v[idx] {
    let s = from.index(from.startIndex, offsetBy: prev)
    let e = from.index(from.startIndex, offsetBy: idx)

    sliceVec.append(from[s..<e])
    idx = prev
  }

  return sliceVec.reversed().joined(separator: " ")
}

public func wordBreak(str: String, dict: Set<String>) -> String? {
  let size = str.count + 1
  var possible = [Int?](repeating: nil, count: size)

  func checkWord(i: Int, j: Int) -> Int? {
    let s = str.index(str.startIndex, offsetBy: i)
    let e = str.index(str.startIndex, offsetBy: j)

    return dict.contains(String(str[s..<e])) ? i : nil
  }

  for i in 1..<size {
    possible[i] ??= checkWord(i: 0, j: i)

    guard possible[i] != nil else {
      continue
    }

    for j in i+1..<size {
      possible[j] ??= checkWord(i: i, j: j)
    }

    if possible[str.count] != nil {
      return createString(str, possible)
    }
  }

  return nil
}
