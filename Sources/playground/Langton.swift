//
// Created by Erik Little on 9/4/18.
//

import Foundation

public final class Langton {
  public let numberOfAnts: Int
  public let size: Int

  private var ants = [Ant]()
  private lazy var maxSteps = numberOfAnts * 30_000
  fileprivate var grid: [[Bool]]

  public init(size: Int, numberOfAnts: Int) {
    self.numberOfAnts = numberOfAnts
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

  public func run() {
    var stepCount = 0

    while !ants.isEmpty {
      // Check and see if the ants are goofing around
      guard stepCount < maxSteps else { break }

      var ant = ants.removeFirst()

      if !ant.step() {
        // Ant didn't escape, put it back
        ants.append(ant)
      }

      stepCount += 1
    }

    for row in grid {
      for col in row {
        print(col ? "‡" : " ", terminator: "")
      }

      print()
    }

    print("\(numberOfAnts - ants.count) escaped")
    print("Took \(stepCount) steps")
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
    direction.changeDirection(isBlack: board.grid[x][y])

    board.grid[x][y].toggle()

    direction.moveAnt(&self)

    return x < 0 || y < 0 || x >= board.size || y >= board.size
  }
}

private enum Direction : CaseIterable {
  case north, south, east, west

  mutating func changeDirection(isBlack: Bool) {
    switch (self, isBlack) {
    case (.north, true):
      self = .west
    case (.north, false):
      self = .east
    case (.south, true):
      self = .east
    case (.south, false):
      self = .west
    case (.east, true):
      self = .north
    case (.east, false):
      self = .south
    case (.west, true):
      self = .south
    case (.west, false):
      self = .north
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

