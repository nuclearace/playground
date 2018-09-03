//
// Created by Erik Little on 9/3/18.
//

import Foundation
import QDBMP

private let orange: (r: UInt8, g: UInt8, b: UInt8) = (255, 158, 22)

final class Brownian {
  let height: Int
  let width: Int
  let numberOfParticles: Int

  private let bmp: OpaquePointer
  // Default RNG is too slow. Use a Mersenne Twister
  private var rng = MTRandom(seed: UInt64.random(in: 0...UInt64.max))

  private var grid: [[Bool]]

  init(height: Int, width: Int, numberOfParticles: Int) {
    self.height = height
    self.width = width
    self.numberOfParticles = numberOfParticles
    self.grid = [[Bool]](repeating: [Bool](repeating: false, count: height), count: width)
    self.bmp = BMP_Create(UInt(width), UInt(height), 24)

    checkError()
  }

  deinit {
    BMP_Free(bmp)
  }

  private func checkError() {
    let err = BMP_GetError()

    guard err == BMP_STATUS(0) else {
      fatalError("\(err)")
    }
  }

  func save() {
    for x in 0..<width {
      for y in 0..<height where grid[x][y] {
        BMP_SetPixelRGB(bmp, UInt(x), UInt(y), orange.r, orange.g, orange.b)
        checkError()
      }
    }

    ("~/Desktop/out.bmp" as NSString).expandingTildeInPath.withCString {s in
      BMP_WriteFile(bmp, s)
    }
  }

  func tree(preview: Bool = false) {
    var (px, py, dx, dy) = (0, 0, 0, 0)

    func randomPoint() {
      px = Int.random(in: 0..<width, using: &rng)
      py = Int.random(in: 0..<height, using: &rng)
    }

    // Seed
    grid[width/3][height/3] = true

    for i in 0..<numberOfParticles-1 {
      print("Putting point \(i + 1)")
      randomPoint()

      let (_, t) = ClockTimer.time {
        while true {
          dx = Int.random(in: -1...1, using: &rng)
          dy = Int.random(in: -1...1, using: &rng)

          let x = dx + px
          let y = dy + py

          if x < 0 || x >= width || y < 0 || y >= height {
            randomPoint()
          } else if grid[x][y] {
            grid[px][py] = true
            break
          } else {
            px += dx
            py += dy
          }
        }
      }

      print("Took \(t.clocks) ticks for a total of \(Double(t.duration) / Double(CLOCKS_PER_SEC))s")

      if preview && i % 100 == 0 {
        save()
      }
    }
  }
}
