//
// Created by Erik Little on 9/8/18.
//

// Church encoding

public func succ<A, B, C>(_ n: @escaping (@escaping (A) -> B) -> (C) -> A) -> (@escaping (A) -> B) -> (C) -> B {
  return {f in
    return {x in
      return f(n(f)(x))
    }
  }
}

public func zero<A, B>(_ a: A) -> (B) -> B {
  return {b in
    return b
  }
}

public func three<A>(_ f: @escaping (A) -> A) -> (A) -> A {
  return {x in
    return succ(succ(succ(zero)))(f)(x)
  }
}

public func four<A>(_ f: @escaping (A) -> A) -> (A) -> A {
  return {x in
    return succ(succ(succ(succ(zero))))(f)(x)
  }
}

public func add<A, B, C>(_ m: @escaping (B) -> (A) -> C) -> (@escaping (B) -> (C) -> A) -> (B) -> (C) -> C {
  return {n in
    return {f in
      return {x in
        return m(f)(n(f)(x))
      }
    }
  }
}

public func mult<A, B, C>(_ m: @escaping (A) -> B) -> (@escaping (C) -> A) -> (C) -> B {
  return {n in
    return {f in
      return m(n(f))
    }
  }
}

public func exp<A, B, C>(_ m: A) -> (@escaping (A) -> (B) -> (C) -> C) -> (B) -> (C) -> C {
  return {n in
    return {f in
      return {x in
        return n(m)(f)(x)
      }
    }
  }
}

public func church<A>(_ x: Int) -> (@escaping (A) -> A) -> (A) -> A {
  guard x != 0 else { return zero }

  return {f in
    return {a in
      return f(church(x - 1)(f)(a))
    }
  }
}

public func unchurch<A>(_ f: (@escaping (Int) -> Int) -> (Int) -> A) -> A {
  return f({i in
    return i + 1
  })(0)
}
