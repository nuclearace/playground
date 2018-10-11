//
// Created by Erik Little on 2018-10-10.
//

import Foundation

public struct CycledSequence<WrappedSequence: Sequence> {
  // MARK: Properties

  private var seq: WrappedSequence
  private var iter: WrappedSequence.Iterator

  // MARK: Initializers

  init(seq: WrappedSequence) {
    self.seq = seq
    self.iter = seq.makeIterator()
  }
}

extension CycledSequence : Sequence, IteratorProtocol {
  public mutating func next() -> WrappedSequence.Element? {
    if let ele = iter.next() {
      return ele
    } else {
      iter = seq.makeIterator()

      return iter.next()
    }
  }
}

extension Sequence {
  public func cycled() -> CycledSequence<Self> {
    return CycledSequence(seq: self)
  }
}
