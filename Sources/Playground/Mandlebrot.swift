//
// Created by Erik Little on 1/4/20.
//

import Foundation
import Numerics

public func mandlebrot(saveTo loc: String = "~/Desktop/mandlebrot.bmp", iterations: Int = 256) {
  let imageSize = 800
  let drawer = BitmapDrawer(height: imageSize, width: imageSize)
  let cxMin = -2.0
  let cxMax = 1.0
  let cyMin = -1.5
  let cyMax = 1.5
  let scaleX = (cxMax - cxMin) / Double(imageSize)
  let scaleY = (cyMax - cyMin) / Double(imageSize)

  for x in 0..<imageSize {
    for y in 0..<imageSize {
      let cx = cxMin + Double(x) * scaleX
      let cy = cyMin + Double(y) * scaleY

      let c = Complex(cx, cy)
      var z = Complex(0.0, 0.0)
      var i = 0

      for t in 0..<iterations {
        guard z.length < 2 else {
          break
        }

        z = z * z + c
        i = t
      }

      drawer.setPixel(x: x, y: y, to: (UInt8(i), UInt8(i), UInt8(i)))
    }
  }

  drawer.save(to: loc)
}
