import ArgumentParser
//import AsyncHTTPClient
import BigInt
import CryptoSwift
import BigNumber
import ClockTimer
// import CGMP
import CStuff
import Foundation
import Playground
import Numerics

print("Angle     0 m              13700 m")
print("------------------------------------")

for z in stride(from: 0.0, through: 90.0, by: 5.0) {
  let air = String(
    format: "%2.0f      %11.8f      %11.8f",
    z,
    airMass(altitude: 0, zenith: z),
    airMass(altitude: 13700, zenith: z)
  )

  print(air)
}
