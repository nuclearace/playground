//
// Created by Erik Little on 2018-10-13.
//

@usableFromInline
typealias DisjointReducer<T: Hashable> = (final: [T], replaces: [T], counts: [T: Int])

@inlinable
public func disjointOrder<T: Hashable>(m: [T], n: [T]) -> [T] {
  let replaceCounts = n.reduce(into: [T: Int](), { $0[$1, default: 0] += 1 })
  let reduced = m.reduce(into: DisjointReducer([T](), n, replaceCounts), {cur, el in
    guard cur.counts[el, default: 0] > 0 else {
      cur.final.append(el)

      return
    }

    cur.final.append(cur.replaces.removeFirst())
    cur.counts[el]? -= 1
  })

  return reduced.final
}
