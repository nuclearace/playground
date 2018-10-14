//
// Created by Erik Little on 2018-10-13.
//

@usableFromInline
typealias DisjointReducer<T: Hashable> = (final: [T], replaces: [T], counts: [T: Int])

// print(disjointOrder(m: ["A", "B", "C", "A", "B", "D", "A", "B", "E"], n: ["E", "A", "D", "A"]))
@inlinable
public func disjointOrder<T: Hashable>(m: [T], n: [T]) -> [T] {
  let replaceCounts = n.reduce(into: [T: Int](), { $0[$1, default: 0] += 1 })
  let reduced = m.reduce(into: DisjointReducer([], n, replaceCounts), {cur, el in
    cur.final.append(cur.counts[el, default: 0] > 0 ? cur.replaces.removeFirst() : el)
    cur.counts[el]? -= 1
  })

  return reduced.final
}
