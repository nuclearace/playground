import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let fileLoc = ("~/Desktop/data.json" as NSString).expandingTildeInPath
let str = try String(contentsOfFile: fileLoc)
let key = "aadfadfasdfadfadfa"

//print(str)

guard let cipher = Vigenere(key: key, smallestCharacter: "\u{9}", largestCharacter: "🛹") else {
  fatalError("could not create cipher")
}

guard let encoded = cipher.encrypt(str) else {
  fatalError("failed to encrypt")
}

print("Encoded: \(encoded)")


guard let decoded = cipher.decrypt(encoded) else {
  fatalError("failed to decrypt")
}

print("Decoded: \(decoded == str)")
