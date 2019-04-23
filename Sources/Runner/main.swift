import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

func nextEaster(on date: (month: Int, day: Int)) -> SimpleDate {
  for year in 2019...Int.max {
    let easter = dateForEaster(year: year)

    if date == (easter.month, easter.day) {
      return easter
    }
  }

  fatalError()
}

print(nextEaster(on: (3, 24)))
