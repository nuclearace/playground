//
// Created by Erik Little on 9/3/18.
//

import Foundation

public final class Brownian: BitmapDrawer {
  public let numberOfParticles: Int

  // Default RNG is too slow. Use a Mersenne Twister
  private var rng = MTRandom()

  public init(height: Int, width: Int, numberOfParticles: Int) {
    self.numberOfParticles = numberOfParticles

    super.init(height: height, width: width)
  }

  public func tree(preview: Bool = false) {
    var (px, py, dx, dy) = (0, 0, 0, 0)

    func randomPoint() {
      px = Int.random(in: 0..<imageWidth, using: &rng)
      py = Int.random(in: 0..<imageHeight, using: &rng)
    }

    // Seed
    grid[imageWidth/3][imageHeight/3] = orange

    for i in 0..<numberOfParticles-1 {
      print("Putting point \(i + 1)")
      randomPoint()

      let (_, t) = ClockTimer.time {
        while true {
          dx = Int.random(in: -1...1, using: &rng)
          dy = Int.random(in: -1...1, using: &rng)

          let x = dx + px
          let y = dy + py

          if x < 0 || x >= imageWidth || y < 0 || y >= imageHeight {
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

      print("Took \(Double(t.duration))s")

      if preview && i % 100 == 0 {
        save()
      }
    }
  }
}
