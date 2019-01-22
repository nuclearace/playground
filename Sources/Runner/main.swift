import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let multis = (1...5).map({degree in
  (1...10).map({member in
    multiFactorial(member, k: degree)
  })
})

for (i, degree) in multis.enumerated() {
  print("Degree \(i + 1): \(degree)")
}

