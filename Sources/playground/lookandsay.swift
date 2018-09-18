//
// Created by Erik Little on 9/9/18.
//


// var seq = [1]
//
// for i in 0..<10 {
//  print("Seq \(i): \(seq)")
//  seq = lookAndSay(seq)
// }
public func lookAndSay(_ seq: [Int]) -> [Int] {
  var result = [Int]()
  var cur = seq[0]
  var curRunLength = 1

  for i in seq.dropFirst() {
    if cur == i {
      curRunLength += 1
    } else {
      result.append(curRunLength)
      result.append(cur)
      curRunLength = 1
      cur = i
    }
  }

  result.append(curRunLength)
  result.append(cur)

  return result
}
