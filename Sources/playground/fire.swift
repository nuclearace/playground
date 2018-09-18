//
// Created by Erik Little on 9/4/18.
//

import Foundation

public final class ForestFire {
  public let ticks: Int
  public let size: Int
  public let printOnTick: Int

  private var forest: [[Plot]]

  public init(ticks: Int, size: Int, printOnTick: Int) {
    self.ticks = ticks
    self.size = size
    self.printOnTick = printOnTick

    forest = [[Plot]](repeating: [Plot](repeating: .empty, count: size), count: size)

    for x in 0..<size {
      for y in 0..<size {
        forest[x][y] = .plantTree()
      }
    }
  }

  private func getNeighbors(for plot: (x: Int, y: Int)) -> [Plot] {
    var neighbors = [Plot]()

    let startX = plot.x > 0 ? -1 : 0
    let endX = plot.x < size - 1 ? 1 : 0
    let startY = plot.y > 0 ? -1 : 0
    let endY = plot.y < size - 1 ? 1 : 0

    for dx in startX...endX {
      for dy in startY...endY where dx != 0 || dy != 0 {
        neighbors.append(forest[plot.x + dx][plot.y + dy])
      }
    }

    return neighbors
  }

  private func printForest() {
    var output = ""

    for row in forest {
      for col in row {
        switch col {
        case .burningTree:
          output += "🔥"
        case .empty:
          output += "🌷"
        case .tree:
          output += "🌲"
        }
      }

      output += "\n"
    }

    print(output)
  }

  public func simulate() {
    printForest()

    for i in 0..<ticks {
      if i % printOnTick == 0 {
        defer {
          printForest()

          guard readLine(strippingNewline: true) != "q" else { exit(0) }
        }

      }

      tick()
    }

    printForest()
  }

  private func tick() {
    var new = forest

    for (x, row) in forest.enumerated() {
      for (y, plot) in row.enumerated() {
        switch plot {
        case .empty:
          new[x][y] = .growTree()
        case .burningTree:
          new[x][y] = .empty
        case .tree where getNeighbors(for: (x, y)).burns():
          new[x][y] = .burningTree
        case .tree:
          new[x][y] = .burnTree()
        }
      }
    }

    forest = new
  }
}

private enum ForestConstants : Double {
  case probabilityIgnite = 0.0001
  case probabilityGrow = 0.01
  case probabilityTree = 0.55
}

private enum Plot {
  case empty
  case tree
  case burningTree

  static func burnTree() -> Plot {
    return Double.random(in: 0..<1.0) <= ForestConstants.probabilityIgnite.rawValue ? .burningTree : .tree
  }

  static func growTree() -> Plot {
    return Double.random(in: 0..<1.0) <= ForestConstants.probabilityGrow.rawValue ? .tree : .empty
  }

  static func plantTree() -> Plot {
    return Double.random(in: 0..<1.0) <= ForestConstants.probabilityTree.rawValue ? .tree : .empty
  }
}

extension Array where Element == Plot {
  fileprivate func burns() -> Bool {
    return reduce(false, { $0 || ($1 == .burningTree) })
  }
}

