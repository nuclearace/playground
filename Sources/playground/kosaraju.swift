//
// Created by Erik Little on 2019-07-30.
//

public func kosaraju(graph: [[Int]]) -> [Int] {
  let size = graph.count
  var x = size
  var vis = [Bool](repeating: false, count: size)
  var l = [Int](repeating: 0, count: size)
  var c = [Int](repeating: 0, count: size)
  var t = [[Int]](repeating: [], count: size)

  func visit(_ u: Int) {
    guard !vis[u] else {
      return
    }

    vis[u] = true

    for v in graph[u] {
      visit(v)
      t[v].append(u)
    }

    x -= 1
    l[x] = u
  }

  for u in 0..<graph.count {
    visit(u)
  }

  func assign(_ u: Int, root: Int) {
    guard vis[u] else {
      return
    }

    vis[u] = false
    c[u] = root

    for v in t[u] {
      assign(v, root: root)
    }
  }

  for u in l {
    assign(u, root: u)
  }

  return c
}
