import BigInt
import CStuff
import Foundation
import Playground
import Dispatch

let text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!";
let key = "VIGENERECIPHER";
let cipher = Vigenere(key: key)!

print("Key: \(key)")
print("Plain Text: \(text)")

let encoded = cipher.encrypt(text.uppercased())!

print("Cipher Text: \(encoded)")

let decoded = cipher.decrypt(encoded)!

print("Decoded: \(decoded)")

print("\nLarger set:")

let key2 = "Vigenere cipher"

let cipher2 = Vigenere(key: key2, smallestCharacter: " ", largestCharacter: "z")!

print("Key: \(key2)")
print("Plain Text: \(text)")

let encoded2 = cipher2.encrypt(text)!

print("Cipher Text: \(encoded2)")

let decoded2 = cipher2.decrypt(encoded2)!

print("Decoded: \(decoded2)")
