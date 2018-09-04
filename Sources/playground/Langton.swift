//
// Created by Erik Little on 9/4/18.
//

import Foundation

final class Langton {
  let size: Int

  private var ants = [Ant]()
  fileprivate var grid: [[Bool]]

  init(size: Int, numberOfAnts: Int) {
    self.size = size
    self.grid = [[Bool]](repeating: [Bool](repeating: false, count: size), count: size)

    let origin = size / 2
    let low = origin - 20
    let high = origin + 20

    for _ in 0..<numberOfAnts {
      let p = Ant(x: Int.random(in: low...high), y: Int.random(in: low...high), board: self)
      ants.append(p)
    }
  }

  func run() {
    var stepCount = 0

    while !ants.isEmpty {
      // Check and see if the ants are goofing around
      guard stepCount < 20_000 else { break }

      var ant = ants.remove(at: 0)

      if !ant.step() {
        // Ant didn't escape, put it back
        ants.append(ant)
      }

      stepCount += 1
    }

    for row in grid {
      for col in row {
        print(col ? "‡" : " ", terminator: " ")
      }

      print()
    }
  }
}

private struct Ant {
  var x: Int
  var y: Int

  private unowned let board: Langton
  private var direction = Direction.allCases.randomElement()!

  init(x: Int, y: Int, board: Langton) {
    self.x = x
    self.y = y
    self.board = board
  }

  /// Moves this ant one tick. Returns true if the ant has escaped
  mutating func step() -> Bool {
    direction = direction.newDirection(black: board.grid[x][y])

    board.grid[x][y].toggle()

    direction.moveAnt(&self)

    return x < 0 || y < 0 || x >= board.size || y >= board.size
  }
}

private enum Direction : CaseIterable {
  case north, south, east, west

  func newDirection(black: Bool) -> Direction {
    switch (self, black) {
    case (.north, true):
      return .west
    case (.north, false):
      return .east
    case (.south, true):
      return .east
    case (.south, false):
      return .west
    case (.east, true):
      return .north
    case (.east, false):
      return .south
    case (.west, true):
      return .south
    case (.west, false):
      return .north
    }
  }

  func moveAnt(_ ant: inout Ant) {
    switch self {
    case .north:
      ant.y -= 1
    case .south:
      ant.y += 1
    case .east:
      ant.x += 1
    case .west:
      ant.x -= 1
    }
  }
}

