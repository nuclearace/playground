import BigInt

let l1 = Line(p1: Point(x: 4.0, y: 0.0), p2: Point(x: 6.0, y: 10.0))
let l2 = Line(p1: Point(x: 0.0, y: 3.0), p2: Point(x: 10.0, y: 7.0))
let l3 = Line(p1: Point(x: 4.0, y: 0.0), p2: Point(x: 6.0, y: 10.0))
let l4 = Line(p1: Point(x: 0.0, y: 3.0), p2: Point(x: 10.0, y: 7.1))
let l5 = Line(p1: Point(x: 0.0, y: 0.0), p2: Point(x: 1.0, y: 1.0))
let l6 = Line(p1: Point(x: 1.0, y: 2.0), p2: Point(x: 4.0, y: 5.0))
let l7 = Line(p1: Point(x: 1.0, y: 2.0), p2: Point(x: 1.0, y: 5.0))
let l8 = Line(p1: Point(x: 0.0, y: 2.0), p2: Point(x: 2.0, y: 2.0))

print("Intersection of \(l1) and \(l2) at: \(String(describing: l1.intersection(of: l2)))")
print("Intersection of \(l3) and \(l4) at: \(String(describing: l3.intersection(of: l4)))")
print("Intersection of \(l5) and \(l6) at: \(String(describing: l5.intersection(of: l6)))")
print("Intersection of \(l1) and \(l7) at: \(String(describing: l1.intersection(of: l7)))")
print("Intersection of \(l1) and \(l8) at: \(String(describing: l1.intersection(of: l8)))")
