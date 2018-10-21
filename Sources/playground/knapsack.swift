//
// Created by Erik Little on 2018-10-21.
//

public struct KnapsackItem : Hashable {
  public var name: String
  public var weight: Int
  public var value: Int

  public init(name: String, weight: Int, value: Int) {
    self.name = name
    self.weight = weight
    self.value = value
  }
}

public func knapsack(items: [KnapsackItem], limit: Int) -> [KnapsackItem] {
  var table = Array(repeating: Array(repeating: 0, count: limit + 1), count: items.count + 1)

  for j in 1..<items.count+1 {
    let item = items[j-1]

    for w in 1..<limit+1 {
      if item.weight > w {
        table[j][w] = table[j-1][w]
      } else {
        table[j][w] = max(table[j-1][w], table[j-1][w-item.weight] + item.value)
      }
    }
  }

  var result = [KnapsackItem]()
  var w = limit

  for j in stride(from: items.count, to: 0, by: -1) where table[j][w] != table[j-1][w] {
    let item = items[j-1]

    result.append(item)

    w -= item.weight
  }

  return result
}
