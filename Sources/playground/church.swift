//
// Created by Erik Little on 9/8/18.
//

import Foundation

// Church encoding

func id<A>(_ a: A) -> A {
  return a
}

func zero<A, B>(_ a : A) -> (B) -> B {
  return {b in
    return b
  }
}

func succ<A, B, C>(_ n : @escaping (@escaping (A) -> B) -> (C) -> A) -> (@escaping (A) -> B) -> (C) -> B {
  return {f in
    return {x in
      return f(n(f)(x))
    }
  }
}

func add<A, B, C>(_ m: @escaping (B) -> (A) -> C) -> (@escaping (B) -> (C) -> A) -> (B) -> (C) -> C {
  return {n in
    return {f in
      return {x in
        return m(f)(n(f)(x))
      }
    }
  }
}

func mult<A, B, C>(_ m : @escaping (A) -> B) -> (@escaping (C) -> A) -> (C) -> B {
  return {n in
    return {f in
      return m(n(f))
    }
  }
}

//func exp<A, B, C>(_ m : @escaping (A) -> B) -> (A) -> C {
//  return {n in
//    return n(m)
//  }
//}

func church<A>(_ x : Int) -> (@escaping (A) -> A) -> (A) -> A {
  if x == 0 {
    return zero
  }

  return {f in
    return {a in
      return f(church(x - 1)(f)(a))
    }
  }
}

func unchurch<A>(_ f : (@escaping (Int) -> Int) -> (Int) -> A) -> A {
  return f({i in
    return i + 1
  })(0)
}
