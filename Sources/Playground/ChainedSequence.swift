//
// Created by Erik Little on 12/20/19.
//

import Foundation

public struct ChainedSequence<Element> {
  @usableFromInline
  var sequences: [AnySequence<Element>]

  @usableFromInline
  var iter: AnyIterator<Element>

  @usableFromInline
  var curSeq = 0

  @usableFromInline
  init<Seq1: Sequence, Seq2: Sequence>(
    _ seq: Seq1,
    _ other: Seq2
  ) where Seq1.Element == Element, Seq2.Element == Element {
    sequences = [AnySequence(seq), AnySequence(other)]
    iter = sequences[curSeq].makeIterator()
  }
}

extension ChainedSequence: Sequence, IteratorProtocol {
  @inlinable
  public mutating func next() -> Element? {
    if let el = iter.next() {
      return el
    }

    curSeq += 1

    guard curSeq != sequences.endIndex else {
      return nil
    }

    iter = sequences[curSeq].makeIterator()

    return iter.next()
  }
}

extension Sequence {
  @inlinable
  public func chained<Seq: Sequence>(with other: Seq) -> ChainedSequence<Element> where Seq.Element == Element {
    return ChainedSequence(self, other)
  }
}
