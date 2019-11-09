//
// Created by Erik Little on 11/6/19.
//

import Foundation

public struct Cell: Hashable {
  public var x: Int
  public var y: Int

  public var neighbors: [Cell] {
    [
      Cell(x: x - 1, y: y - 1),
      Cell(x: x,     y: y - 1),
      Cell(x: x + 1, y: y - 1),
      Cell(x: x - 1, y: y),
      Cell(x: x + 1, y: y),
      Cell(x: x - 1, y: y + 1),
      Cell(x: x,     y: y + 1),
      Cell(x: x + 1, y: y + 1),
    ]
  }

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

    for cell in cells.flatMap({ $0.neighbors }) {
      counts[cell, default: 0] += 1
    }

    return counts
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

  public mutating func run(iterations: Int, sim: Bool = false) {
    if sim {
      print("\u{001B}[2J\u{001B}[f", terminator: "")
    }

    print("(0) num cells: \(cells.count)")
    printColony()
    print()

    if sim && requestQuit() {
      return
    }

    for i in 1...iterations {
      guard !cells.isEmpty else {
        return
      }

      if sim {
        print("\u{001B}[2J\u{001B}[f", terminator: "")
      }

      runGeneration()
      print("(\(i)) num cells: \(cells.count)")
      printColony()

      if sim && requestQuit() {
        return
      } else {
        print()
      }
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
