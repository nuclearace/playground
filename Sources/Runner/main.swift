import BigInt
import CStuff
import Foundation
import Playground

let pows = (0...)
    .lazy
    .map({ Int(pow(3, Double($0))) })
    .map(populationCount)
    .prefix(30)

let evils = (0...)
    .lazy
    .filter({ populationCount(n: $0) & 1 == 0 })
    .prefix(30)

let odious = (0...)
    .lazy
    .filter({ populationCount(n: $0) & 1 == 1 })
    .prefix(30)

let pernicious = (0...)
    .lazy
    .filter({ populationCount(n: $0).isPrime })
    .prefix(25)

let perniciousMore = (888_888_877...888_888_888)
    .filter({ populationCount(n: $0).isPrime })


print("Powers:", Array(pows))
print("Evils:", Array(evils))
print("Odious:", Array(odious))
print("Pernicious:", Array(pernicious))
print("Pernicious 888,888,877 - 888,888,888:", Array(perniciousMore))
