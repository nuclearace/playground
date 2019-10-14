import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let key = "this is some key🤮"
let text = "this is a string 😂😂😂😂😂😂 with unicode ü"

let cipher = Vigenere(key: key, smallestCharacter: " ", largestCharacter: "🛹")!

guard let encoded = cipher.encrypt(text) else {
  fatalError()
}

print(encoded)

guard let decoded = cipher.decrypt(encoded) else {
  fatalError()
}

print(decoded)
