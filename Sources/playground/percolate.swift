//
// Created by Erik Little on 2018-10-14.
//

private let randMax = 32767.0
private let filled = 1
private let rightWall = 2
private let bottomWall = 4

public final class Percolate {
  public let height: Int
  public let width: Int

  private var grid: [Int]
  private var end: Int
  private var rng = MTRandom(seed: .random(in: 0...UInt64.max))

  public init(height: Int, width: Int) {
    self.height = height
    self.width = width
    self.end = width
    self.grid = [Int](repeating: 0, count: width * (height + 2))
  }

  private func fill(at p: Int) -> Bool {
    guard grid[p] & filled == 0 else { return false }

    grid[p] |= filled

    guard p < end else { return true }

    return (((grid[p + 0] & bottomWall) == 0) && fill(at: p + width)) ||
            (((grid[p + 0] & rightWall) == 0) && fill(at: p + 1)) ||
            (((grid[p - 1] & rightWall) == 0) && fill(at: p - 1)) ||
            (((grid[p - width] & bottomWall) == 0) && fill(at: p - width))
  }

  public func makeGrid(porosity p: Double) {
    resetGrid()

    let thresh = Int(randMax * p)

    for i in 0..<width {
      grid[i] = bottomWall | rightWall
    }

    for _ in 0..<height {
      for _ in stride(from: width - 1, through: 1, by: -1) {
        let r1 = Int.random(in: 0..<Int(randMax)+1, using: &rng)
        let r2 = Int.random(in: 0..<Int(randMax)+1, using: &rng)

        grid[end] = (r1 < thresh ? bottomWall : 0) | (r2 < thresh ? rightWall : 0)

        end += 1
      }

      let r3 = Int.random(in: 0..<Int(randMax)+1, using: &rng)

      grid[end] = rightWall | (r3 < thresh ? bottomWall : 0)

      end += 1
    }
  }

  @discardableResult
  public func percolate() -> Bool {
    var i = 0

    while i < width && !fill(at: width + i) {
      i += 1
    }

    return i < width
  }

  private func resetGrid() {
    end = width

    for i in 0..<grid.count {
      grid[i] = 0
    }
  }

  public func showGrid() {
    for _ in 0..<width {
      print("+--", terminator: "")
    }

    print("+")

    for i in 0..<height {
      print(i == height ? " " : "|", terminator: "")

      for j in 0..<width {
        print(grid[i * width + j + width] & filled != 0 ? "[]" : "  ", terminator: "")
        print(grid[i * width + j + width] & rightWall != 0 ? "|" : " ", terminator: "")
      }

      print()

      guard i != height else { return }

      for j in 0..<width {
        print(grid[i * width + j + width] & bottomWall != 0 ? "+--" : "+  ", terminator: "")
      }

      print("+")
    }
  }
}
