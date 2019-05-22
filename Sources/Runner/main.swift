import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

extension Collection {
  func grouped<T: Equatable>(on property: KeyPath<Element, T>) -> [[Element]] {
    guard !isEmpty else {
      return []
    }

    var groups = [[first!]]

    main: for thing in self[index(after: startIndex)...] {
      for (i, var group) in groups.enumerated() {
        if group.first![keyPath: property] == thing[keyPath: property] {
          group.append(thing)

          groups[i] = group

          continue main
        }
      }

      groups.append([thing])
    }

    return groups
  }
}

struct Person {
  var name: String
  var age: Int
}

let people = (10...85).flatMap({age in (1...5).map({ Person(name: "\($0)", age: age) }) }).shuffled()

print(people.grouped(on: \.age))
