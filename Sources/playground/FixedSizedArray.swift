//
// Created by Erik Little on 2019-05-30.
//

import Foundation

@usableFromInline
class FixedSizedBacking<ElementType> {
  let capacity: Int

  @usableFromInline
  var storage: UnsafeMutablePointer<ElementType>

  @usableFromInline
  init(capacity: Int) {
    self.capacity = capacity
    storage = .allocate(capacity: MemoryLayout<ElementType>.stride * capacity)
  }

  @usableFromInline
  init(copying: FixedSizedBacking) {
    capacity = copying.capacity
    storage = .allocate(capacity: MemoryLayout<ElementType>.stride * capacity)

    memcpy(storage, copying.storage, MemoryLayout<ElementType>.stride * capacity)
  }

  @usableFromInline
  deinit {
    storage.deallocate()
  }
}

public struct FixedSizedArray<ElementType> {
  @usableFromInline
  var backing: FixedSizedBacking<ElementType>

  @inlinable
  public subscript(index: Int) -> ElementType {
    @inlinable
    get {
      return backing.storage[index]
    }

    @inlinable
    set {
      if isKnownUniquelyReferenced(&backing) {
        backing.storage[index] = newValue
      } else {
        backing = FixedSizedBacking(copying: backing)
        backing.storage[index] = newValue
      }
    }
  }

  @inlinable
  public init(capacity: Int) {
    backing = FixedSizedBacking(capacity: capacity)
  }
}

extension FixedSizedArray: Collection {
  public var startIndex: Int {
    return 0
  }

  public var endIndex: Int {
    return backing.capacity
  }

  public func index(after i: Int) -> Int {
    precondition(i != endIndex, "Cannot get index after endIndex")

    return i + 1
  }
}

extension FixedSizedArray: MutableCollection {

}
