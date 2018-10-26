import BigInt
import CStuff
import Foundation
import Playground

var list = DoubleLinkedList<Int>()
var arr = [2, 3, 4, 5]

func printList() {
  for el in list {
    print(el)
  }
}

list.append(2)
list.append(3)
list.append(4)
list.append(5)

printList()

list.replaceSubrange(0...3, with: [])

printList()
