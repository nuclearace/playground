import BigInt
import CStuff
import Foundation
import Playground

print(disjointOrder(m: ["the", "cat", "sat", "on", "the", "mat"], n: ["mat", "cat"]))
print(disjointOrder(m: ["the", "cat", "sat", "on", "the", "mat"], n: ["cat", "mat"]))
print(disjointOrder(m: ["A", "B", "C", "A", "B", "C", "A", "B", "C"], n: ["C", "A", "C", "A"]))
print(disjointOrder(m: ["A", "B", "C", "A", "B", "D", "A", "B", "E"], n: ["E", "A", "D", "A"]))
print(disjointOrder(m: ["A", "B"], n: ["B"]))
print(disjointOrder(m: ["A", "B"], n: ["B", "A"]))
print(disjointOrder(m: ["A", "B", "B", "A"], n: ["B", "A"]))
