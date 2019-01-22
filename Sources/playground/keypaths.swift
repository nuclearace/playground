//
// Created by Erik Little on 2018-10-04.
//

import Foundation

// alice <-> \Person.age <-> bob <-> \Person.name <-> bob
infix operator <-> : SwapGroup

precedencegroup SwapGroup {
  associativity: left
}

public func <-> <T, V>(lhs: inout T, rhs: WritableKeyPath<T, V>) -> SwapHolder<T, V> {
  return SwapHolder(thing: &lhs, path: rhs)
}

@discardableResult
public func <-> <T, V>(lhs: SwapHolder<T, V>, rhs: T) -> PartialSwapHolder<T> {
  lhs.applyChange(withValue: rhs[keyPath: lhs.path])

  return PartialSwapHolder(thing: lhs.thing)
}

public func <-> <T, V>(lhs: PartialSwapHolder<T>, rhs: WritableKeyPath<T, V>) -> SwapHolder<T, V> {
  return SwapHolder(thing: lhs.thing, path: rhs)
}

public struct PartialSwapHolder<SwapType> {
  fileprivate var thing: UnsafeMutablePointer<SwapType>
}

public struct SwapHolder<SwapType, SwapValue> {
  fileprivate var thing: UnsafeMutablePointer<SwapType>
  fileprivate var path: WritableKeyPath<SwapType, SwapValue>

  fileprivate func applyChange(withValue value: SwapValue) {
    thing.pointee[keyPath: path] = value
  }
}

