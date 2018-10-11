import BigInt
import CStuff
import Foundation
import Playground

print([1, 2, 4, 5]
    .cycled()
    .lazy
    .prefix(5)
    .reduce(0, +))

let arr1 = (0...).cycled().lazy
let arr2 = (1...).cycled().lazy
let arr3 = replicateAtLeastOnce([1, 5].cycled(), times: 5).lazy.flatMap({ $0 }).map({ $0 + 2 }).prefix(20)

print(zip(arr1, arr2).prefix(20).map(+))
print(Array(arr3))
