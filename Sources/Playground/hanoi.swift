//
// Created by Erik Little on 11/21/19.
//

import Foundation

public struct TowersOfHanoi<T> {
  public struct Tower: CustomStringConvertible {
    public var i: Int

    public var disks: [T]

    public var description: String {
      return "\(disks)"
    }

    public init(i: Int, disks: [T]) {
      self.i = i
      self.disks = disks
    }
  }

  @inlinable
  public static func hanoi(source: inout Tower, target: inout Tower, aux: inout Tower) {
    func move(n: Int, source: inout Tower, target: inout Tower, aux: inout Tower) {
      guard n != 0 else {
        return
      }

      // move n - 1 disks from source to aux, so they are out of the way
      move(n: n - 1, source: &source, target: &aux, aux: &target)

      // move the nth disk from the source to the target
      target.disks.append(source.disks.popLast()!)

      print("\([source, target, aux].sorted(by: { $0.i < $1.i }))\n==================")

      // ove the n - 1 disks from the aux to the target
      move(n: n - 1, source: &aux, target: &target, aux: &source)
    }

    move(n: source.disks.count, source: &source, target: &target, aux: &aux)
  }
}
