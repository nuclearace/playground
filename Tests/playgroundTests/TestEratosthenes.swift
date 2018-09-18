//
// Created by Erik Little on 9/18/18.
//

import BigInt
import SwiftCheck
import XCTest
@testable import Playground

public final class TestEratosthenes : XCTestCase {
  func testPrimes() {
    property("Eratosthenes returns primes") <- forAll {(n: Int) in
      let primes = Array(Eratosthenes(upTo: abs(n)))

      return primes.count > 1 ==> {
        let primeNumberGen = Gen<Int>.fromElements(of: primes)

        return forAll(primeNumberGen) {(p: Int) in
          return isPrime(n: p)
        }
      }
    }
  }

  public static var allCases: [(String, (TestEratosthenes) -> () -> ())] {
    return [
      ("testPrimes", testPrimes)
    ]
  }
}

private func isPrime(n : Int) -> Bool {
  if n == 0 || n == 1 {
    return false
  } else if n == 2 {
    return true
  }

  let max = Int(ceil(sqrt(Double(n))))

  for i in 2...max {
    if n % i == 0 {
      return false
    }
  }
  return true
}
