import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let tests = [
  "123456789.123456789",
  ".123456789",
  "57256.1D-4",
  "pi=3.14159265358979323846264338327950288419716939937510582097494459231",
  "The author has two Z$100000000000000 Zimbabwe notes (100 trillion).",
  "-in Aus$+1411.8millions",
  "===US$0017440 millions=== (in 2000 dollars)",
  "123.e8000 is pretty big.",
  "The land area of the earth is 57268900(29% of the surface) square miles.",
  "Ain't no numbers in this here words, nohow, no way, Jose.",
  "James was never known as 0000000007",
  "Arthur Eddington wrote: I believe there are " +
      "15747724136275002577605653961181555468044717914527116709366231425076185631031296" +
      " protons in the universe.",
  "   $-140000±100 millions.",
  "6/9/1946 was a good year for some."
]

print(tests[0].commatize(period: 2, separator: "*"))
print(tests[1].commatize(period: 3, separator: "-"))
print(tests[2].commatize(period: 4, separator: "__"))
print(tests[3].commatize(period: 5, separator: " "))
print(tests[4].commatize(separator: "."))

for testCase in tests.dropFirst(5) {
  print(testCase.commatize())
}

