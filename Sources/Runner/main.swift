import BigInt
import CStuff
import Foundation
import Playground
import Numerics

let fmt = { String(format: "%lf", $0) }

print("Mean of angles (350, 10) => \(fmt(meanOfAngles([350, 10])))")
print("Mean of angles (90, 180, 270, 360) => \(fmt(meanOfAngles([90, 180, 270, 360])))")
print("Mean of angles (10, 20, 30) => \(fmt(meanOfAngles([10, 20, 30])))")
