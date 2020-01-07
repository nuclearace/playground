import BigInt
import CStuff
import Foundation
import Playground
import Numerics

let testCases = [
  ("H", "1.008"),
  ("H2", "2.016"),
  ("H2O", "18.015"),
  ("H2O2", "34.014"),
  ("(HO)2", "34.014"),
  ("Na2SO4", "142.036"),
  ("C6H12", "84.162"),
  ("COOH(C(CH3)2)3CH3", "186.295"),
  ("C6H4O2(OH)4", "176.124"),
  ("C27H46O", "386.664"),
  ("Uue", "315.000")
]

let fmt = { String(format: "%.3f", $0) }

for (mol, expected) in testCases {
  guard let mass = Chem.calculateMolarMass(of: mol) else {
    fatalError("Bad formula \(mol)")
  }

  assert(fmt(mass) == expected, "Incorrect result")

  print("\(mol) => \(fmt(mass))")
}
