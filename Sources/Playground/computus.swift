//
// Created by Erik Little on 2019-04-22.
//

public struct SimpleDate: Equatable {
  public var year: Int
  public var month: Int
  public var day: Int

  public init(year: Int, month: Int, day: Int) {
    self.year = year
    self.month = month
    self.day = day
  }
}

public enum CalendarType {
  case julian
  case gregorian
}

public func dateForEaster(year: Int, calendar: CalendarType = .gregorian) -> SimpleDate {
  switch calendar {
  case .gregorian:
    return gregorianEaster(year: year)
  case .julian:
    return julianEaster(year: year)
  }
}

// Anonymous Gregorian algorithm
public func gregorianEaster(year: Int) -> SimpleDate {
  let a = year % 19
  let b = year / 100
  let c = year % 100
  let d = b / 4
  let e = b % 4
  let f = (b + 8) / 25
  let g = (b - f + 1) / 3
  let h = ((19 * a) + b - d - g + 15) % 30
  let i = c / 4
  let k = c % 4
  let ℓ = (32 + (2 * e) + (2 * i) - h - k) % 7
  let m = (a + (11 * h) + (22 * ℓ)) / 451

  return SimpleDate(year: year, month: (h + ℓ - (7 * m) + 114) / 31, day: ((h + ℓ - (7 * m) + 114) % 31) + 1)
}

// Meeus's Julian algorithm
public func julianEaster(year: Int) -> SimpleDate {
  let a = year % 4
  let b = year % 7
  let c = year % 19
  let d = (19 * c + 15) % 30
  let e = (2 * a + 4 * b - d + 34) % 7

  return SimpleDate(year: year, month: (d + e + 114) / 31, day: ((d + e + 114) % 31) + 1)
}
