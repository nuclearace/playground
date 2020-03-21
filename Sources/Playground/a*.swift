//
// Created by Erik Little on 3/21/20.
//

import Foundation
import Numerics

@usableFromInline
let maxScore = 99999999

public struct GridPosition: Hashable {
  public var x: Int
  public var y: Int

  public init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }

  public func distance(to: GridPosition) -> Int {
    let dx = Double.pow(Double(to.x - x), 2)
    let dy = Double.pow(Double(to.y - y), 2)

    return Int((dx + dy).squareRoot())
  }
}

extension GridPosition: CustomDebugStringConvertible {
  public var debugDescription: String { "(\(x), \(y))" }
}

public typealias Barrier = Set<GridPosition>

public protocol Grid {
  var barriers: [Barrier] { get }
  var size: Int { get }

  func getNeighbours(position: GridPosition) -> [GridPosition]
}

extension Grid {
  public func heuristicDistance(start: GridPosition, finish: GridPosition) -> Int {
    let dx = abs(start.x - finish.x)
    let dy = abs(start.y - finish.y)

    return (dx + dy) + (-2) * min(dx, dy)
  }

  @inlinable
  public func inBarrier(_ pos: GridPosition) -> Bool { barriers.contains(where: { $0.contains(pos) }) }

  @inlinable
  public func moveCost(from: GridPosition, to: GridPosition) -> Int { inBarrier(to) ? maxScore : 1 }
}

public struct SquareGrid: Grid {
  public var height: Int
  public var width: Int
  public var barriers: [Barrier]
  public var size: Int { height * width }

  public init(height: Int, width: Int, barriers: [Barrier]) {
    self.height = height
    self.width = width
    self.barriers = barriers
  }

  public func getNeighbours(position: GridPosition) -> [GridPosition] {
    return [
      GridPosition(x: position.x + 1, y: position.y),
      GridPosition(x: position.x - 1, y: position.y),
      GridPosition(x: position.x, y: position.y + 1),
      GridPosition(x: position.x, y: position.y - 1),
      GridPosition(x: position.x + 1, y: position.y + 1),
      GridPosition(x: position.x - 1, y: position.y + 1),
      GridPosition(x: position.x + 1, y: position.y - 1),
      GridPosition(x: position.x - 1, y: position.y - 1),
    ].filter({ inGrid($0) })
  }

  private func inGrid(_ pos: GridPosition) -> Bool {
    (0..<height).contains(pos.x) && (0..<width).contains(pos.y)
  }
}

@inlinable
public func aStarSearch(start: GridPosition, finish: GridPosition, grid: Grid) -> ([GridPosition], Int)? {
  #if DEBUG
  let idealDist = start.distance(to: finish)
  #endif

  func generatePath(currentPos: GridPosition, cameFrom: [GridPosition: GridPosition]) -> [GridPosition] {
    var path = [currentPos]
    var current = currentPos

    while let c = cameFrom[current] {
      current = c
      path.insert(current, at: 0)
    }

    return path
  }

  var openVertices: Set = [start]
  var closedVertices: Set<GridPosition> = []
  var costFromStart = [start: 0]
  var estimatedTotalCost = [start: grid.heuristicDistance(start: start, finish: finish)]
  var cameFrom = Dictionary<GridPosition, GridPosition>()

  while !openVertices.isEmpty {
    #if DEBUG
    let tot = costFromStart.keys.count + estimatedTotalCost.keys.count + cameFrom.keys.count
    let totCap = costFromStart.capacity + estimatedTotalCost.capacity + cameFrom.capacity
    let space = String(format: "%.3f", (Double(closedVertices.count) / Double(grid.size)) * 100)

    print("\u{001B}[2J\u{001B}[f", terminator: "")
    print("Searching for path to \(finish.debugDescription):... Approx distance: \(idealDist)")
    print("Open Vertices: \(openVertices.count), Capacity: \(openVertices.capacity)")
    print("Closed Vertices: \(closedVertices.count), Capacity: \(closedVertices.capacity), Space Explored: \(space)%")
    print("Cost From Start + Estimated Total + Came From: \(tot), Capacity: \(totCap)")

//    Thread.sleep(forTimeInterval: 0.0001)
    #endif

    let (currentPos, _) = openVertices.lazy
      .map({ ($0, estimatedTotalCost[$0]) })
      .filter({ $0.1 != nil })
      .min(by: { $0.1! < $1.1! })!

    if currentPos == finish {
      let path = generatePath(currentPos: currentPos, cameFrom: cameFrom)

      return (path, estimatedTotalCost[finish]!)
    }

    openVertices.remove(currentPos)
    closedVertices.insert(currentPos)

    let neighbors = grid.getNeighbours(position: currentPos).filter({ !closedVertices.contains($0) })

    for neighbor in neighbors {
      let score = costFromStart[currentPos]! + grid.moveCost(from: currentPos, to: neighbor)

      if score < costFromStart[neighbor, default: maxScore] {
        if !openVertices.contains(neighbor) {
          openVertices.insert(neighbor)
        }

        cameFrom[neighbor] = currentPos
        costFromStart[neighbor] = score
        estimatedTotalCost[neighbor] = score + grid.heuristicDistance(start: neighbor, finish: finish)
      }
    }
  }

  return nil
}
