import BigInt
import CStuff
import Foundation
import Playground
import Numerics

print("Self-describing numbers less than 100,000,000:")

DispatchQueue.concurrentPerform(iterations: 100_000_000) {i in
  defer {
    if i == 100_000_000 - 1 {
      exit(0)
    }
  }

  guard i.isSelfDescribing else {
    return
  }

  print(i)
}

dispatchMain()
