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

extension Cell: CustomStringConvertible {
  public var description: String {
    return "Cell(x: \(x), y: \(y))"
  }
}

extension Cell: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "{x: \(x), y: \(y)}"
  }
}

public struct Colony {
  public var numCells: Int { cells.count }

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
    if sim && whatNow(i: 0) {
      return
    }

    for i in 1...iterations {
      guard !cells.isEmpty else {
        return
      }

      runGeneration()

      if sim && whatNow(i: i) {
        return
      } else {
        continue
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

  public func saveImage(to: String = "~/Desktop/out.bmp") {
    guard !cells.isEmpty else {
      return
    }

    let adjustX: Int
    let adjustY: Int

    var top = cells.first!
    var bottom = cells.first!
    var left = cells.first!
    var right = cells.first!

    for cell in cells {
      if cell.x < left.x {
        left = cell
      } else if cell.x > right.x {
        right = cell
      }

      if cell.y < top.y {
        top = cell
      } else if cell.y > bottom.y {
        bottom = cell
      }
    }

    if left.x < 0 {
      adjustX = abs(left.x)
    } else {
      adjustX = 0
    }

    if top.y < 0 {
      adjustY = abs(top.y)
    } else {
      adjustY = 0
    }

    let imageHeight = bottom.y + adjustY + 1
    let imageWidth = right.x + adjustX + 1

    let drawer = BitmapDrawer(height: imageHeight, width: imageWidth)

    for cell in cells {
      let x = cell.x + adjustX
      let y = cell.y + adjustY

      assert(
        x >= 0 && y >= 0 && x <= imageWidth && y <= imageHeight,
        "\(cell) \(x) \(y) \(imageWidth) \(imageHeight)"
      )

      drawer.setPixel(x: x, y: y, to: orange)
    }

    drawer.save(to: to)
  }

  private func whatNow(i: Int) -> Bool {
    print("\u{001B}[2J\u{001B}[f", terminator: "")
    print("(\(i)) num cells: \(cells.count)")
    print("What now? Nothing) continue; p) print to screen q) stop sim; s) save image: ", terminator: "")

    guard let input = readLine(strippingNewline: true) else {
      return true
    }

    switch input.lowercased() {
    case "s":
      saveImage()
    case "p":
      printColony()
    case "q":
      return true
    case _:
      break
    }

    return false
  }
}

public func runLife(height: Int, width: Int) {
  var seed = Set<Cell>()

  func resetSeed(_ numSeeds: Int) {
    seed.removeAll()

    while seed.count != numSeeds {
      seed.insert(Cell(x: .random(in: 0..<width), y: .random(in: 0..<height)))
    }
  }

  func getNumSeeds() -> Int? {
    print("Enter number of seeds, or anything else to stop: ", terminator: "")

    guard let num = readLine(strippingNewline: true) else {
      return nil
    }

    return Int(num)
  }

  var col: Colony

  while let numSeeds = getNumSeeds() {
    resetSeed(numSeeds)
    col = Colony(cells: seed, height: height, width: width)

    col.saveImage(to: "~/Desktop/initial.bmp")
    col.run(iterations: 1000, sim: true)
    col.saveImage()
  }
}
