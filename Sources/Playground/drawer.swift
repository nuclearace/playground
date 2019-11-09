//
// Created by Erik Little on 2018-09-25.
//

import Foundation
import QDBMP

public protocol Drawer {
  var imageHeight: Int { get }
  var imageWidth: Int { get }
  var origin: (Int, Int) { get }

  func save(to path: String)
  func setPixel(x: Int, y: Int, to color: Color?)
}

public protocol Drawable {
  func draw<T: Drawer>(into drawer: inout T)
}

public typealias Color = (red: UInt8, green: UInt8, blue: UInt8)

let orange = Color(red: 255, green: 158, blue: 22)

public class BitmapDrawer: Drawer {
  /// The height of the portrait
  public let imageHeight: Int

  /// The width of the portrait
  public let imageWidth: Int

  /// The origin of the portrait
  public var origin: (Int, Int) {
    return (imageWidth/2, imageHeight/2)
  }

  /// The portrait that is being drawn
  var grid: [[Color?]]

  private let bmp: OpaquePointer

  public init(height: Int, width: Int) {
    self.imageHeight = height
    self.imageWidth = width
    self.grid = [[Color?]](repeating: [Color?](repeating: nil, count: height), count: width)
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

  public func drawGrid() {
    let (oX, oY) = origin

    for x in 0..<imageWidth {
      grid[x][oY] = (255, 255, 255)
    }

    for y in 0..<imageHeight {
      grid[oX][y] = (255, 255, 255)
    }
  }

  public func save(to path: String = "~/Desktop/out.bmp") {
    for x in 0..<imageWidth {
      for y in 0..<imageHeight {
        guard let color = grid[x][y] else { continue }

        BMP_SetPixelRGB(bmp, UInt(x), UInt(y), color.red, color.green, color.blue)
        checkError()
      }
    }

    (path as NSString).expandingTildeInPath.withCString {s in
      BMP_WriteFile(bmp, s)
    }
  }

  public func setPixel(x: Int, y: Int, to color: Color?) {
    grid[x][y] = color
  }
}
