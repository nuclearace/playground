//
// Created by Erik Little on 11/29/19.
//

private let stx = "\u{2}"
private let etx = "\u{3}"

public func bwt(_ str: String) -> String? {
  guard !str.contains(stx), !str.contains(etx) else {
    return nil
  }

  let ss = stx + str + etx
  let table = ss.indices.map({i in ss[i...] + ss[ss.startIndex..<i] }).sorted()

  return String(table.map({str in str.last!}))
}

public func ibwt(_ str: String) -> String? {
  let len = str.count
  var table = Array(repeating: "", count: len)

  for _ in 0..<len {
    for i in 0..<len {
      table[i] = String(str[str.index(str.startIndex, offsetBy: i)]) + table[i]
    }

    table.sort()
  }

  for row in table where row.hasSuffix(etx) {
    return String(row.dropFirst().dropLast())
  }

  return nil
}
