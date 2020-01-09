import BigInt
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

let rd = ["22", "333", "4444", "55555", "666666", "7777777", "88888888", "999999999"]

for d in 2...9 {
  print("First 10 super-\(d) numbers:")

  var count = 0
  var n = BigInt(3)
  var k = BigInt(0)
//  var n = mpz_t()
//  var k = mpz_t()
//  var working = mpz_t()
//
//  __gmpz_init(&n)
//  __gmpz_init(&k)
//  __gmpz_init(&working)
//  __gmpz_set_si(&n, 3)

  let (_, t) = ClockTimer.time {
    while true {
      k = n.power(d)
      k *= BigInt(d)

//      __gmpz_pow_ui(&k, &n, UInt(d))
//      __gmpz_set(&working, &k)
//      __gmpz_mul_ui(&k, &working, UInt(d))

//      guard let strPtr = __gmpz_get_str(nil, 10, &k) else {
//        fatalError()
//      }

//      let str = String(cString: strPtr)

      let str = String(k)

//      free(strPtr)

      if let _ = str.range(of: rd[d - 2]) {
        count += 1

//        guard let nPtr = __gmpz_get_str(nil, 10, &n) else {
//          fatalError()
//        }

        print(n, terminator: " ")

//        print(String(cString: nPtr), terminator: " ")
//        free(nPtr)

        fflush(stdout)

        guard count < 10 else {
          break
        }
      }

      n += 1

//      __gmpz_set(&working, &n)
//      __gmpz_add_ui(&n, &working, 1)
    }
  }

  print("\n took \(t.duration)s")
  print()
}
