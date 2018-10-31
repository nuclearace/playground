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
    clearList()
  }

  @discardableResult
  fileprivate func addFirstValue(_ value: Value) -> UnsafeMutablePointer<DListNode<Value>> {
    let p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)

    p.pointee = DListNode(value: value, prev: nil, next: nil)
    head = p
    tail = p

    return p
  }

  private func clearList() {
    var cur = head

    while let node = cur {
      let tmpNode = node.pointee.next

      node.deallocate()

      cur = tmpNode
    }

    head = nil
    tail = nil
  }

  private func node(at i: Int) -> UnsafeMutablePointer<DListNode<Value>>? {
    guard i >= 0 && i < count else {
      return nil
    }

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
  private func insert<C>(atSubrange subrange: Range<Int>, _ newElements: C) where C: Collection, C.Element == Value {
    let lenRange = subrange.upperBound - subrange.lowerBound

    var node: UnsafeMutablePointer<DListNode<Value>>?

    if subrange.lowerBound == count {
      var p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)

      if !isEmpty {
        node = self.node(at: count - 1)
      }

      tail = p

      if head == nil {
        head = p
      }

      for el in newElements {
        defer {
          p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)
        }

        node?.pointee.next = p
        p.pointee = DListNode(value: el, prev: node, next: nil)
      }

      // Cleanup unused p
      p.deallocate()
    } else if !newElements.isEmpty {
      node = self.node(at: subrange.lowerBound)
      let fNode = node

      var p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)

      if node == head {
        head = p
      }

      // Splice in the new node
      node?.pointee.prev?.pointee.next = p
      node = node?.pointee.prev

      for el in newElements {
        defer {
          p = UnsafeMutablePointer<DListNode<Value>>.allocate(capacity: 1)
        }

        p.pointee = DListNode(value: el, prev: fNode?.pointee.prev, next: fNode)

        fNode?.pointee.prev = p
        node?.pointee.next = p
        node = p
      }

      // Cleanup unused p
      p.deallocate()
    }

  }

  public func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Element == Value {
//    precondition(subrange.lowerBound >= startIndex && subrange.upperBound < endIndex)

    let lenRange = subrange.upperBound - subrange.lowerBound

    var node: UnsafeMutablePointer<DListNode<Value>>?

    defer {
      count += newElements.count - lenRange
    }

    if lenRange == 0 {
      print("insert at")
      insert(atSubrange: subrange, newElements)

      return
    }

    if newElements.isEmpty {
      removeElements(subrange)

      return
    }
  }

  private func removeElements(_ subrange: Range<Int>) {
    var node: UnsafeMutablePointer<DListNode<Value>>?

    node = self.node(at: subrange.lowerBound)
    let endNode = self.node(at: subrange.upperBound)

    if node == head {
      head = endNode
    }

    if endNode == nil {
      tail = node?.pointee.prev
    }

    while node != endNode {
      let tmpNode = node?.pointee.next

      // FIXME: This isn't right, this can break the prev field
      node?.pointee.next?.pointee.prev = node?.pointee.prev
      node?.pointee.prev?.pointee.next = node?.pointee.next

      node?.deallocate()

      node = tmpNode
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
