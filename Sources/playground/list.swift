//
// Created by Erik Little on 2018-10-25.
//

import Foundation

public final class DoubleLinkedList<Value> {
  public private(set) var count = 0

  private var head: UnsafeMutablePointer<DListNode<Value>>?
  private var tail: UnsafeMutablePointer<DListNode<Value>>?

  public init() { }

  deinit {
    var cur = head

    while let node = cur {
      node.pointee.prev?.deallocate()
      cur = node.pointee.next
    }

    tail?.deallocate()
  }

  @discardableResult
  fileprivate func addFirstValue(_ value: Value) -> UnsafeMutablePointer<DListNode<Value>> {
    let p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)

    p.pointee = DListNode(value: value, prev: nil, next: nil)
    head = p
    tail = head

    return p
  }

  public func append(_ value: Value) {
    count += 1

    let p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)
    var node = DListNode(value: value, prev: nil, next: nil)

    guard tail != nil else {
      addFirstValue(value)

      return
    }

    node.prev = tail
    p.pointee = node
    tail?.pointee.next = p
    tail = p
  }
}

extension DoubleLinkedList : Collection, MutableCollection {
  public var startIndex: Int {
    return 0
  }

  public var endIndex: Int {
    return count
  }

  public subscript(position: Int) -> Value {
    get {
      return node(at: position).pointee.value
    }

    set {
      node(at: position).pointee.value = newValue
    }
  }

  public func index(after i: Int) -> Int {
    precondition(i >= 0 && i < count)

    return i + 1
  }

  private func node(at i: Int) -> UnsafeMutablePointer<DListNode<Value>> {
    precondition(i >= 0 && i < count)

    var curI = 0
    var cur = head!

    while curI != i {
      cur = cur.pointee.next!

      curI += 1
    }

    return cur
  }
}

extension DoubleLinkedList : RangeReplaceableCollection {
  public func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == Value {
//    precondition(subrange.lowerBound >= startIndex && subrange.upperBound < endIndex)

    let lenRange = subrange.upperBound - subrange.lowerBound

    var node: UnsafeMutablePointer<DListNode<Value>>

    if isEmpty {
      node = addFirstValue(newElements.first!)
    } else if lenRange != 0 {
      node = self.node(at: subrange.lowerBound)
    } else {
      node = self.node(at: subrange.lowerBound - 1)
    }

    if lenRange < newElements.count {
      let numAdd = newElements.count - lenRange

      count += numAdd

      for el in newElements.dropLast(numAdd) {
        node.pointee.value = el
        node = node.pointee.next!
      }

      var nodePast: UnsafeMutablePointer<DListNode<Value>>

      (node, nodePast) = (node.pointee.prev ?? node, node)

      // Fill in the gap between node and nodeLast
      for el in newElements.dropFirst(lenRange) {
        let p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)
        p.pointee = DListNode(value: el, prev: node, next: nil)

        node.pointee.next = p
        node = p
      }

      node.pointee.next = nodePast
      nodePast.pointee.prev = node
    } else if lenRange > newElements.count {
      let numRemove = lenRange - newElements.count

      count -= numRemove

      for el in newElements {
        node.pointee.value = el
        node = node.pointee.next!
      }

      let nodePast = node.pointee.prev!

      for _ in 0..<numRemove {
        let tmpNext = node.pointee.next!

        node.pointee.prev?.pointee.next = node.pointee.next

        node.deallocate()

        node = tmpNext
      }

      nodePast.pointee.next = node
    } else {
      guard !newElements.isEmpty else { return }

      for el in newElements {
        node.pointee.value = el
        node = node.pointee.next!
      }
    }
  }
}

private struct DListNode<Value> {
  var value: Value

  var prev: UnsafeMutablePointer<DListNode>?
  var next: UnsafeMutablePointer<DListNode>?

  init(value: Value, prev: UnsafeMutablePointer<DListNode>?, next: UnsafeMutablePointer<DListNode>?) {
    self.value = value
    self.prev = prev
    self.next = next
  }
}
