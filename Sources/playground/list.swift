//
// Created by Erik Little on 2018-10-25.
//

import Foundation

public final class DoubleLinkedList<Value> {
  public private(set) var count = 0

  private var head: UnsafeMutablePointer<DListNode<Value>>?

  public init() { }

  deinit {
    var cur = head

    while let node = cur {
      let tmpNode = node.pointee.next

      node.deallocate()

      cur = tmpNode
    }
  }

  @discardableResult
  fileprivate func addFirstValue(_ value: Value) -> UnsafeMutablePointer<DListNode<Value>> {
    let p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)

    p.pointee = DListNode(value: value, prev: nil, next: nil)
    head = p

    return p
  }

  private func node(at i: Int) -> UnsafeMutablePointer<DListNode<Value>>? {
    assert(i >= 0 && i < count)

    var curI = 0
    var cur = head

    while curI != i, cur != nil {
      cur = cur?.pointee.next

      curI += 1
    }

    return cur
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
      return node(at: position)!.pointee.value
    }

    set {
      node(at: position)!.pointee.value = newValue
    }
  }

  public func index(after i: Int) -> Int {
    precondition(i >= 0 && i < count)

    return i + 1
  }
}

extension DoubleLinkedList : RangeReplaceableCollection {
//  public func append(_ value: Value) {
//    count += 1
//
//    let p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)
//    var node = DListNode(value: value, prev: nil, next: nil)
//
//    guard tail != nil else {
//      addFirstValue(value)
//
//      return
//    }
//
//    node.prev = tail
//    p.pointee = node
//    tail?.pointee.next = p
//    tail = p
//  }

  public func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == Value {
//    precondition(subrange.lowerBound >= startIndex && subrange.upperBound < endIndex)

    let lenRange = subrange.upperBound - subrange.lowerBound

    var node: UnsafeMutablePointer<DListNode<Value>>?

    defer {
      count += newElements.count - lenRange
    }

//    if isEmpty && !newElements.isEmpty {
//      node = addFirstValue(newElements.first!)
//    } else if lenRange != 0 {
//      node = self.node(at: subrange.lowerBound)
//    } else {
//      node = self.node(at: subrange.lowerBound - 1)
//    }

    // Handle just adding new elements
    if lenRange == 0 {
      guard !newElements.isEmpty else { return }

      guard !isEmpty else {
        node = addFirstValue(newElements.first!)

        for el in newElements.dropFirst() {
          let p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)
          p.pointee = DListNode(value: el, prev: node, next: nil)

          node?.pointee.next = p
          node = p
        }

        return
      }

      if subrange.lowerBound != 0 {
        node = self.node(at: subrange.lowerBound - 1)
      } else {
        node = head
      }

      let lastPrev = node?.pointee.next

      for (i, el) in newElements.enumerated() {
        let p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)
        p.pointee = DListNode(value: el, prev: node, next: nil)

        if node == head && i == 0 {
          head = p
        }

        node?.pointee.next = p
        node = p
      }

      node?.pointee.next = lastPrev
      lastPrev?.pointee.prev = node

      return
    }

    if newElements.isEmpty {
      guard !isEmpty else { return }

      if subrange.lowerBound != 0 {
        node = self.node(at: subrange.lowerBound - 1)
      } else {
        node = head
      }

      for _ in 0..<lenRange {
        let tmpNode = node?.pointee.next

        if node == head {
          head = tmpNode
        }

        node?.pointee.prev?.pointee.next = tmpNode
        node?.pointee.next?.pointee.prev = node?.pointee.prev

        node?.deallocate()

        node = tmpNode
      }

      return
    }


//    if lenRange < newElements.count {
//      let numAdd = newElements.count - lenRange
//
//      count += numAdd
//
//      guard count != 1 else {
//        return
//      }
//
//      for el in newElements.dropLast(numAdd) {
//        node?.pointee.value = el
//        node = node?.pointee.next
//      }
//
//      var nodePast: UnsafeMutablePointer<DListNode<Value>>?
//
//      (node, nodePast) = (node?.pointee.prev, node)
//
//      // Fill in the gap between node and nodeLast
//      for el in newElements.dropFirst(lenRange) {
//        let p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)
//        p.pointee = DListNode(value: el, prev: node ?? nodePast, next: nil)
//
//        node?.pointee.next = p
//        node = p
//      }
//
//      if lenRange != 0 {
//        node?.pointee.next = nodePast
//        nodePast?.pointee.prev = node
//      }
//    } else if lenRange > newElements.count {
//      let numRemove = lenRange - newElements.count
//
//      count -= numRemove
//
//      for el in newElements {
//        node?.pointee.value = el
//        node = node?.pointee.next
//      }
//
//      let nodePast = node?.pointee.prev
//
//      for _ in 0..<numRemove {
//        let tmpNext = node?.pointee.next
//
//        node?.pointee.prev?.pointee.next = node?.pointee.next
//        node?.deallocate()
//
//        node = tmpNext
//      }
//
//      nodePast?.pointee.next = node
//    } else {
//      guard !newElements.isEmpty else { return }
//
//      for el in newElements {
//        node?.pointee.value = el
//        node = node?.pointee.next
//      }
//    }
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
