import BigInt
import CStuff
import Foundation
import Playground
import Numerics

var a = TowersOfHanoi.Tower(i: 0, disks: [Int]())
var b = TowersOfHanoi.Tower(i: 1, disks: [Int]())
var c = TowersOfHanoi.Tower(i: 2, disks: [Int]())

for i in stride(from: 16, to: 0, by: -1) {
  a.disks.append(i)
}

TowersOfHanoi.hanoi(source: &a, target: &c, aux: &b)


