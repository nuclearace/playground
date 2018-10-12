//
// Created by Erik Little on 9/3/18.
//

import Foundation
import QDBMP

private let orange = Color(red: 255, green: 158, blue: 22)

public final class Brownian : BitmapDrawer {
  public let numberOfParticles: Int

  // Default RNG is too slow. Use a Mersenne Twister
  private var rng = MTRandom(seed: UInt64.random(in: 0...UInt64.max))

  public init(height: Int, width: Int, numberOfParticles: Int) {
    self.numberOfParticles = numberOfParticles

    super.init(height: height, width: width)
  }

  public func tree(preview: Bool = false) {
    var (px, py, dx, dy) = (0, 0, 0, 0)

    func randomPoint() {
      px = Int.random(in: 0..<width, using: &rng)
      py = Int.random(in: 0..<height, using: &rng)
    }

    // Seed
    grid[width/3][height/3] = orange

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
          } else if grid[x][y] != nil {
            grid[px][py] = orange
            break
          } else {
            px += dx
            py += dy
          }
        }
      }

      print("Took \(t.clocks) ticks for a total of \(Double(t.duration))s")

      if preview && i % 100 == 0 {
        save()
      }
    }
  }
}
