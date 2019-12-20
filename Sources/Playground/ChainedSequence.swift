//
// Created by Erik Little on 12/20/19.
//

import Foundation

public struct ChainedSequence<Element> {
  private var sequences: [AnySequence<Element>]
  private var iter: AnyIterator<Element>
  private var curSeq = 0

  init(chain: ChainedSequence) {
    self.sequences = chain.sequences
    self.iter = chain.iter
    self.curSeq = chain.curSeq
  }

  init<Seq: Sequence>(_ seq: Seq) where Seq.Element == Element {
    sequences = [AnySequence(seq)]
    iter = sequences[curSeq].makeIterator()
  }

  func chained<Seq: Sequence>(with seq: Seq) -> ChainedSequence where Seq.Element == Element {
    var res = ChainedSequence(chain: self)

    res.sequences.append(AnySequence(seq))

    return res
  }
}

extension ChainedSequence: Sequence, IteratorProtocol {
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
  public func chained<Seq: Sequence>(with other: Seq) -> ChainedSequence<Element> where Seq.Element == Element {
    return ChainedSequence(self).chained(with: other)
  }
}

