//
// Created by Erik Little on 2018-09-25.
//

import Foundation
import QDBMP

public protocol Drawer {
  var height: Int { get }
  var width: Int { get }
  var origin: (Int, Int) { get }

  init(height: Int, width: Int)

  func save(to path: String)
  func setPixel(x: Int, y: Int, to color: Color?)
}

public protocol Drawable {
  func draw<T: Drawer>(into drawer: inout T)
}

public typealias Color = (red: UInt8, green: UInt8, blue: UInt8)

public class BitmapDrawer : Drawer {
  /// The height of the portrait
  public let height: Int

  /// The width of the portrait
  public let width: Int

  /// The origin of the portrait
  public var origin: (Int, Int) {
    return (width/2, height/2)
  }

  /// The portrait that is being drawn
  var grid: [[Color?]]

  private let bmp: OpaquePointer

  public required init(height: Int, width: Int) {
    self.height = height
    self.width = width
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

  public func save(to path: String = "~/Desktop/out.bmp") {
    for x in 0..<width {
      for y in 0..<height {
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
