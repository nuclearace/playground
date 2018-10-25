import BigInt
import CStuff
import Foundation
import Playground

var list = DoubleLinkedList<Int>()
var arr = [2, 3, 4, 5]

list.append(2)
list.append(3)
list.append(4)
list.append(5)

list.replaceSubrange(0..<3, with: [200, 201])
arr.replaceSubrange(0..<3, with: [200, 201])


list.append(contentsOf: [2, 4, 5, 6, 7, 3])
arr.append(contentsOf: [2, 4, 5, 6, 7, 3])

for el in list {
  print(el)
}

print(arr)
