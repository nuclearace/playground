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

    if lenRange == 0 {
      print("insert at")

      if subrange.lowerBound == count {
        // Handle insert
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

      return
    }

    if newElements.isEmpty {
      print("Remove elements \(lenRange)")

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
