//
// Created by Erik Little on 11/6/19.
//

import Foundation

public struct Cell: Hashable {
  public var x: Int
  public var y: Int

  public init(x: Int, y: Int) {
    (self.x, self.y) = (x, y)
  }
}

public struct Colony {
  private var height: Int
  private var width: Int
  private var cells: Set<Cell>

  public init(cells: Set<Cell>, height: Int, width: Int) {
    self.cells = cells
    self.height = height
    self.width = width
  }

  private func neighborCounts() -> [Cell: Int] {
    var counts = [Cell: Int]()

    for cell in cells.flatMap(Colony.neighbors(for:)) {
      counts[cell, default: 0] += 1
    }

    return counts
  }

  private static func neighbors(for cell: Cell) -> [Cell] {
    return [
      Cell(x: cell.x - 1, y: cell.y - 1),
      Cell(x: cell.x,     y: cell.y - 1),
      Cell(x: cell.x + 1, y: cell.y - 1),
      Cell(x: cell.x - 1, y: cell.y),
      Cell(x: cell.x + 1, y: cell.y),
      Cell(x: cell.x - 1, y: cell.y + 1),
      Cell(x: cell.x,     y: cell.y + 1),
      Cell(x: cell.x + 1, y: cell.y + 1),
    ]
  }

  public func printColony() {
    for y in 0..<height {
      for x in 0..<width {
        let char = cells.contains(Cell(x: x, y: y)) ? "0" : "."

        print("\(char) ", terminator: "")
      }

      print()
    }
  }

  public mutating func run(iterations: Int) {
    print("(0)")
    printColony()
    print()

    for i in 1...iterations {
      print("(\(i))")
      runGeneration()
      printColony()
      print()
    }
  }

  private mutating func runGeneration() {
    cells = Set(neighborCounts().compactMap({keyValue in
      switch (keyValue.value, cells.contains(keyValue.key)) {
      case (2, true), (3, _):
        return keyValue.key
      case _:
        return nil
      }
    }))
  }
}
