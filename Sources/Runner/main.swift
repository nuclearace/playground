import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

protocol Dividable {
  static func / (lhs: Self, rhs: Self) -> Self
}

extension Int: Dividable { }

struct Solution<T: SignedNumeric & Comparable & Dividable> {
  var quotient: Poly<T>
  var remainder: Poly<T>
}

struct Poly<T: SignedNumeric & Comparable & Dividable> {
  typealias PolyType = SignedNumeric & Comparable & Dividable

  private(set) var poly: [T]

  var degree: Int {
    for i in stride(from: poly.count - 1, through: 0, by: -1) where poly[i] != 0 {
      return i
    }

    return Int.min
  }

  init(builder: (PolyBuilder) -> PolyBuilder) {
    poly = builder(PolyBuilder()).getPoly()
  }

  private init(size: Int) {
    self.poly = [T](repeating: 0, count: size)
  }

  init(poly: [T]) {
    self.poly = poly
  }

  func shiftedRight(spots: Int) -> Poly {
    guard spots > 0 else {
      return self
    }

    let deg = degree

    assert(deg + spots < poly.count, "Number of places to shift too large")

    var res = self

    for i in stride(from: deg, through: 0, by: -1) {
      res.poly[i + spots] = res.poly[i]
      res.poly[i] = 0
    }

    return res
  }

  static func *= (lhs: inout Poly, rhs: T) {
    for i in 0..<lhs.poly.count {
      lhs.poly[i] *= rhs
    }
  }

  static func -= (lhs: inout Poly, rhs: Poly) {
    for i in 0..<lhs.poly.count {
      lhs.poly[i] -= rhs.poly[i]
    }
  }

  static func / (lhs: Poly, rhs: Poly) -> Solution<T>? {
    guard lhs.poly.count == rhs.poly.count else {
      return nil
    }

    var nDeg = lhs.degree
    let dDeg = rhs.degree

    guard dDeg >= 0, nDeg >= dDeg else {
      return nil
    }

    var n2 = lhs
    var quo = Poly(size: lhs.poly.count)

    while nDeg >= dDeg {
      let i = nDeg - dDeg
      var d2 = rhs.shiftedRight(spots: i)

      quo.poly[i] = n2.poly[nDeg] / d2.poly[nDeg]

      d2 *= quo.poly[i]
      n2 -= d2
      nDeg = n2.degree
    }

    return Solution(quotient: quo, remainder: n2)
  }
}

extension Poly {
  class PolyBuilder {
    struct Term {
      unowned var builder: PolyBuilder
      var coeff: T
      var exp: Int?

      init(builder: PolyBuilder, coeff: T, exp: Int? = nil) {
        self.builder = builder
        self.coeff = coeff
        self.exp = exp
      }

      static func ^ (lhs: Term, rhs: Int) -> PolyBuilder {
        lhs.builder.terms.append(Term(builder: lhs.builder, coeff: lhs.coeff, exp: rhs))

        return lhs.builder
      }
    }

    private var terms = [Term]()

    func getPoly() -> [T] {
      guard let maxDegree = terms.max(by: {lhs, rhs in
        switch (lhs.exp, rhs.exp) {
        case (_, nil): return false
        case (nil, _): return true
        case let (lhs?, rhs?): return lhs < rhs
        }
      }) else {
        return []
      }

      var left: T = 0
      var poly = [T](repeating: 0, count: maxDegree.exp! + 1)

      for term in terms {
        guard let i = term.exp else {
          left += term.coeff

          continue
        }

        poly[i] = term.coeff
      }

      poly[0] = left

      return poly
    }

    static func * (lhs: T, rhs: PolyBuilder) -> Term {
      return Term(builder: rhs, coeff: lhs)
    }

    static func ^ (lhs: PolyBuilder, rhs: Int) -> PolyBuilder {
      lhs.terms.append(Term(builder: lhs, coeff: 1, exp: rhs))

      return lhs
    }

    static func - (lhs: PolyBuilder, rhs: PolyBuilder) -> PolyBuilder {
      guard var t = lhs.terms.last else {
        return lhs
      }

      t.coeff = -t.coeff

      lhs.terms[lhs.terms.count - 1] = t

      return lhs
    }

    static func + (lhs: PolyBuilder, rhs: PolyBuilder) -> PolyBuilder {
      return lhs
    }

    static func + (lhs: PolyBuilder, rhs: T) -> PolyBuilder {
      lhs.terms.append(Term(builder: lhs, coeff: rhs))

      return lhs
    }

    static func - (lhs: PolyBuilder, rhs: T) -> PolyBuilder {
      lhs.terms.append(Term(builder: lhs, coeff: -rhs))

      return lhs
    }
  }
}

extension Poly: CustomStringConvertible {
  var description: String {
    let deg = degree

    var res = ""

    for i in stride(from: deg, through: 0, by: -1) where poly[i] != 0 {
      let coeff = poly[i]

      switch coeff {
      case 1 where i < deg:
        res += " + "
      case 1:
        break
      case -1 where i < deg:
        res += " - "
      case -1:
        res += "-"
      case _ where coeff < 0 && i < deg:
        res += " - \(-coeff)"
      case _ where i < deg:
        res += " + \(coeff)"
      case _:
        res += "\(coeff)"
      }

      if i > 1 {
        res += "x^\(i)"
      } else if i == 1 {
        res += "x"
      }
    }

    return res
  }
}

let n = Poly {(x: Poly<Int>.PolyBuilder) in
  ((x^3) - (12*x^2) - 42) as Poly<Int>.PolyBuilder
}

print(n)

let d = Poly {(x: Poly<Int>.PolyBuilder) in
  x - 3
}

print(d)
