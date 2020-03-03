//
// Created by Erik Little on 3/3/20.
//

public struct SeqClass: CustomStringConvertible {
  public var seq: [Int]
  public var desc: String

  public var description: String {
    return "\(desc):    \(seq)"
  }
}

public func classifySequence(k: Int, threshold: Int = 1 << 47) -> SeqClass {
  var last = k
  var seq = [k]

  while true {
    last = last.factors().dropLast().reduce(0, +)
    seq.append(last)

    let n = seq.count

    if last == 0 {
      return SeqClass(seq: seq, desc: "Terminating")
    } else if n == 2 && last == k {
      return SeqClass(seq: seq, desc: "Perfect")
    } else if n == 3 && last == k {
      return SeqClass(seq: seq, desc: "Amicable")
    } else if n >= 4 && last == k {
      return SeqClass(seq: seq, desc: "Sociable[\(n - 1)]")
    } else if last == seq[n - 2] {
      return SeqClass(seq: seq, desc: "Aspiring")
    } else if seq.dropFirst().dropLast(2).contains(last) {
      return SeqClass(seq: seq, desc: "Cyclic[\(n - 1 - seq.firstIndex(of: last)!)]")
    } else if n == 16 || last > threshold {
      return SeqClass(seq: seq, desc: "Non-terminating")
    }
  }

  fatalError()
}
