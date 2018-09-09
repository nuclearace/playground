import Foundation

var pop = 0.5

for i in 0..<20 {
  guard pop >= 0.01 else { break }

  print("Pop \(i): \(pop)")

  pop = populationNext(lambda: 3.2, initial: pop)
}
