import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

//let longPi = "3." + DigitsOfPi().prefix(100).dropFirst().lazy.map({ String($0) }).joined()
//
//guard let bigPi = BigDecimal(longPi) else {
//  fatalError()
//}
//
//print(bigPi * 0.01)
//
//let a = BigDecimal(1)
//let b = BigDecimal(998001)
//let c = BigDecimal("-0.00001")!
////let d = bigPi / BigDecimal("0.0005")!
////
////print(BigDecimal("3.14159")!.power(-3))
//print(a / b)

let tests = [
  ("Hello Rosetta Code world", "Hello ", " world"),
  ("Hello Rosetta Code world", "start", " world"),
  ("Hello Rosetta Code world", "Hello ", "end"),
  ("</div><div style=\"chinese\">你好嗎</div>", "<div style=\"chinese\">", "</div>"),
  ("<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>"),
  ("<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>"),
  ("The quick brown fox jumps over the lazy other fox", "quick ", " fox"),
  ("One fish two fish red fish blue fish", "fish ", " red"),
  ("FooBarBazFooBuxQuux", "Foo", "Foo")
]

for (input, start, end) in tests {
  print("Input: \"\(input)\"")
  print("Start delimiter: \"\(start)\"")
  print("End delimiter: \"\(end)\"")
  print("Text between: \"\(input.textBetween(start, and: end))\"\n")
}
