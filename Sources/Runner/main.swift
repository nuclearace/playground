import BigInt
import CStuff
import Foundation
import Playground
import Numerics

for n in 2...29 where n.isPrime {
  print("The first 25 \(n)-smooth numbers are: \(smoothN(n: n, count: 25))")
}

print()

for n in 3...29 where n.isPrime {
  print("The 3000...3002 \(n)-smooth numbers are: \(smoothN(n: BigInt(n), count: 3002).dropFirst(2999).prefix(3))")
}

print()

for n in 503...521 where n.isPrime {
  print("The 30,000...30,019 \(n)-smooth numbers are: \(smoothN(n: BigInt(n), count: 30_019).dropFirst(29999).prefix(20))")
}
