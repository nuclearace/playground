import BigInt
import CStuff
import Foundation
import Playground

let items = [
  KnapsackItem(name: "map", weight: 9, value: 150), KnapsackItem(name: "compass", weight: 13, value: 35),
  KnapsackItem(name: "water", weight: 153, value: 200), KnapsackItem(name: "sandwich", weight: 50, value: 160),
  KnapsackItem(name: "glucose", weight: 15, value: 60), KnapsackItem(name: "tin", weight: 68, value: 45),
  KnapsackItem(name: "banana", weight: 27, value: 60), KnapsackItem(name: "apple", weight: 39, value: 40),
  KnapsackItem(name: "cheese", weight: 23, value: 30), KnapsackItem(name: "beer", weight: 52, value: 10),
  KnapsackItem(name: "suntan cream", weight: 11, value: 70), KnapsackItem(name: "camera", weight: 32, value: 30),
  KnapsackItem(name: "t-shirt", weight: 24, value: 15), KnapsackItem(name: "trousers", weight: 48, value: 10),
  KnapsackItem(name: "umbrella", weight: 73, value: 40), KnapsackItem(name: "waterproof trousers", weight: 42, value: 70),
  KnapsackItem(name: "waterproof overclothes", weight: 43, value: 75), KnapsackItem(name: "note-case", weight: 22, value: 80),
  KnapsackItem(name: "sunglasses", weight: 7, value: 20), KnapsackItem(name: "towel", weight: 18, value: 12),
  KnapsackItem(name: "socks", weight: 4, value: 50), KnapsackItem(name: "book", weight: 30, value: 10)
]

let kept = knapsack(items: items, limit: 500)

print("Kept: ")

for item in kept {
  print("  \(item.name)")
}

let (tValue, tWeight) = kept.reduce((0, 0), { ($0.0 + $1.value, $0.1 + $1.weight) })

print("For a total value of \(tValue) and a total weight of \(tWeight)")
