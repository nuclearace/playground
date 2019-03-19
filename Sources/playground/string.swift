//
// Created by Erik Little on 2019-03-19.
//

import Foundation

extension String {
  private static let commaReg = try! NSRegularExpression(pattern: "(\\.[0-9]+|[1-9]([0-9]+)?(\\.[0-9]+)?)")

  public func commatize(start: Int = 0, period: Int = 3, separator: String = ",") -> String {
    guard separator != "" else {
      return self
    }

    let sep = Array(separator)
    let startIdx = index(startIndex, offsetBy: start)
    let matches = String.commaReg.matches(in: self, range: NSRange(startIdx..., in: self))

    guard !matches.isEmpty else {
      return self
    }

    let fullMatch = String(self[Range(matches.first!.range(at: 0), in: self)!])
    let splits = fullMatch.components(separatedBy: ".")
    var ip = splits[0]

    if ip.count > period {
      var builder = Array(ip.reversed())

      for i in stride(from: (ip.count - 1) / period * period, through: period, by: -period) {
        builder.insert(contentsOf: sep, at: i)
      }

      ip = String(builder.reversed())
    }

    if fullMatch.contains(".") {
      var dp = splits[1]

      if dp.count > period {
        var builder = Array(dp)

        for i in stride(from: (dp.count - 1) / period * period, through: period, by: -period) {
          builder.insert(contentsOf: sep, at: i)
        }

        dp = String(builder)
      }

      ip += "." + dp
    }

    return String(prefix(start)) + String(dropFirst(start)).replacingOccurrences(of: fullMatch, with: ip)
  }
}