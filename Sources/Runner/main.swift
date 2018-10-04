import BigInt
import CStuff
import Foundation
import Playground

struct Person : Equatable {
  var name: String
  var age: Int
}

var alice = Person(name: "Alice", age: 26)
let bob = Person(name: "Bob", age: 23)

print(alice == bob)

alice <-> \Person.age <-> bob <-> \Person.name <-> bob

print(alice == bob)

