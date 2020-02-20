import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

typealias Polygon = Playground.Polygon

let subj = Polygon(points: [
  (50.0, 150.0),
  (200.0, 50.0),
  (350.0, 150.0),
  (350.0, 300.0),
  (250.0, 300.0),
  (200.0, 250.0),
  (150.0, 350.0),
  (100.0, 250.0),
  (100.0, 200.0)
])

let clip = Polygon(points: [
  (100.0, 100.0),
  (300.0, 100.0),
  (300.0, 300.0),
  (100.0, 300.0)
])

print(sutherlandHodgmanClip(subjPoly: subj, clipPoly: clip))
