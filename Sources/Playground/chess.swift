//
// Created by Erik Little on 10/6/21.
//

import Foundation

public func isValid960Position(_ firstRank: String) -> Bool {
  var rooksPlaced = 0
  var bishopColor = -1

  for (i, piece) in firstRank.enumerated() {
    switch piece {
    case "♚" where rooksPlaced != 1:
      return false
    case "♜":
      rooksPlaced += 1
    case "♝" where bishopColor == -1:
      bishopColor = i & 1
    case "♝" where bishopColor == i & 1:
      return false
    case _:
      continue
    }
  }

  return true
}

public func startingFEN(from firstRank: String) -> String {
  let whiteRank = String(
    firstRank.map({piece in
      switch piece {
      case "♚": return "K"
      case "♛": return "Q"
      case "♜": return "R"
      case "♝": return "B"
      case "♞": return "N"
      case _: fatalError()
      }
    })
  )

  return "\(whiteRank.lowercased())/pppppppp/8/8/8/8/PPPPPPPP/\(whiteRank) w KQkq - 0 1"
}

public func get960Position() -> String {
  var pieces = ["♚", "♛", "♜", "♜", "♝", "♝", "♞", "♞"]
  var placedRook = false
  var placedKing = false
  var bishopColor = -1 // 0 - white 1 - black
  var output = ""

  while !pieces.isEmpty {
    let piece = pieces.removeRandom()

    switch piece {
    case _ where !placedRook && pieces.count == 2:
      output += "♜♚♜"
      pieces = []
    case _ where pieces.count == 1 && (piece == "♝" || pieces.contains("♝")):
      let otherPiece = pieces.removeFirst()

      if bishopColor == -1 {
        output += "♝♝"
      } else {
        // Currently on black, other bishop on black, so place down other piece
        if bishopColor == 1 {
          output += "\(piece == "♝" ? otherPiece : piece)♝"
        } else {
          output += "♝\(piece == "♝" ? otherPiece : piece)"
        }
      }
    case "♞", "♛":
      output += piece
    case "♚" where placedRook:
      output += piece
      placedKing = true
    case "♜" where placedKing:
      fallthrough
    case "♜" where !placedRook && !placedKing:
      output += piece
      placedRook = true
    case "♝" where bishopColor == -1:
      output += piece
      bishopColor = pieces.count & 1
    case "♝" where pieces.count & 1 != bishopColor:
      output += piece
    case _:
      pieces.append(piece)
      continue
    }
  }

  assert(isValid960Position(output), "invalid 960 position \(output)")

  return output
}

private struct Chess960Counts {
  var king = 0, queen = 0, rook = 0, bishop = 0, knight = 0

  subscript(_ piece: String) -> Int {
    get {
      switch piece {
      case "♚": return king
      case "♛": return queen
      case "♜": return rook
      case "♝": return bishop
      case "♞": return knight
      case _:   fatalError()
      }
    }

    set {
      switch piece {
      case "♚": king = newValue
      case "♛": queen = newValue
      case "♜": rook = newValue
      case "♝": bishop = newValue
      case "♞": knight = newValue
      case _:   fatalError()
      }
    }
  }
}

public func get960PositionV2() -> String {
  var counts = Chess960Counts()
  var bishopColor = -1 // 0 - white 1 - black
  var output = ""

  for i in 1...8 {
    let validPieces = [
      counts["♜"] == 1 && counts["♚"] == 0 ? "♚" : nil, // king
      i == 1 || (counts["♛"] == 0) ? "♛" : nil, // queen
      i == 1 || (counts["♜"] == 0 || counts["♜"] < 2 && counts["♚"] == 1) ? "♜" : nil, // rook
      i == 1 || (counts["♝"] < 2 && bishopColor == -1 || bishopColor != i & 1) ? "♝" : nil, // bishop
      i == 1 || (counts["♞"] < 2) ? "♞" : nil // knight
    ].lazy.compactMap({ $0 })

    guard let chosenPiece = validPieces.randomElement() else {
      // Need to swap last piece with a bishop
      output.insert("♝", at: output.index(before: output.endIndex))

      break
    }

    counts[chosenPiece] += 1
    output += chosenPiece

    if bishopColor == -1 && chosenPiece == "♝" {
      bishopColor = i & 1
    }
  }

  assert(isValid960Position(output), "invalid 960 position \(output)")

  return output
}
