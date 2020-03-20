import BigInt
import ClockTimer
import CGMP
import CStuff
import Foundation
import Playground
import Numerics

struct Tamagotchi {
  var name: String
  var age = 0
  var bored = 0
  var food = 2
  var poop = 0
}

private var rng = MTRandom()
private var tama = Tamagotchi(name: "")

let verbs = [
  "Ask", "Ban", "Bash", "Bite", "Break", "Build",
  "Cut", "Dig", "Drag", "Drop", "Drink", "Enjoy",
  "Eat", "End", "Feed", "Fill", "Force", "Grasp",
  "Gas", "Get", "Grab", "Grip", "Hoist", "House",
  "Ice", "Ink", "Join", "Kick", "Leave", "Marry",
  "Mix", "Nab", "Nail", "Open", "Press", "Quash",
  "Rub", "Run", "Save", "Snap", "Taste", "Touch",
  "Use", "Vet", "View", "Wash", "Xerox", "Yield",
]

let nouns = [
  "arms", "bugs", "boots", "bowls", "cabins", "cigars",
  "dogs", "eggs", "fakes", "flags", "greens", "guests",
  "hens", "hogs", "items", "jowls", "jewels", "juices",
  "kits", "logs", "lamps", "lions", "levers", "lemons",
  "maps", "mugs", "names", "nests", "nights", "nurses",
  "orbs", "owls", "pages", "posts", "quests", "quotas",
  "rats", "ribs", "roots", "rules", "salads", "sauces",
  "toys", "urns", "vines", "words", "waters", "zebras",
]

let boredIcons = ["💤", "💭", "❓"]
let foodIcons = ["🍼", "🍔", "🍟", "🍰", "🍜"]
let poopIcons = ["💩"]
let sickIcons1 = ["😄", "😃", "😀", "😊", "😎", "👍"]
let sickIcons2 = ["😪", "😥", "😰", "😓"]
let sickIcons3 = ["😩", "😫"]
let sickIcons4 = ["😡", "😱"]
let sickicons5 = ["❌", "💀", "👽", "😇"]

func braces(_ runes: [String]) -> String {
  "{ \(runes.joined(separator: ", ")) }" 
}

func alive() -> Bool {
  sickness() <= 10
}

func sickness() -> Int {
  tama.poop + tama.bored + max(0, tama.age - 32) + abs(tama.food - 2)
}

func feed() {
  tama.food += 1
}

func play() {
  tama.bored = max(0, tama.bored - .random(in: 0...1, using: &rng))
}

func talk() {
  print("😮 : \(verbs.randomElement()!) the \(nouns.randomElement(using: &rng)!)")

  tama.bored = max(0, tama.bored - 1)
}

func clean() {
  tama.poop = max(0, tama.poop - 1)
}

func wait() {
  tama.age += 1
  tama.bored += .random(in: 0...1, using: &rng)
  tama.food = max(0, tama.food - 2)
  tama.poop += .random(in: 0...1, using: &rng)
}

func status() -> String {
  guard alive() else {
    return "R.I.P"
  }

  var bored = [String]()
  var food = [String]()
  var poop = [String]()

  for _ in 0..<tama.bored {
    bored.append(boredIcons.randomElement()!)
  }

  for _ in 0..<tama.food {
    food.append(foodIcons.randomElement()!)
  }

  for _ in 0..<tama.poop {
    poop.append(poopIcons.randomElement()!)
  }

  return "\(braces(bored)) \(braces(food)) \(braces(poop))"
}

func health() {
  let s = sickness()
  let sickRune: String

  switch s {
  case Int.min..<0, 0, 1, 2:
    sickRune = sickIcons1.randomElement()!
  case 3, 4:
    sickRune = sickIcons2.randomElement()!
  case 5, 6:
    sickRune = sickIcons3.randomElement()!
  case 7, 8, 9, 10:
    sickRune = sickIcons4.randomElement()!
  case _:
    sickRune = sickicons5.randomElement()!
  }

  print("\(tama.name) (🎂 \(tama.age))  \(s) \(sickRune) \(status())")
}

func blurb() {
  print("When the '?' prompt appears, enter an action optionally")
  print("followed by the number of repetitions")
  print("If no repetitions are specified, one will be assumed.")
  print("The available options are: feed, play, talk, clean or wait.\n")
}

print("         TAMAGOTCHI EMULATOR")
print("         ===================\n")
print("Enter the name of your tamagotchi : ")

guard let name = readLine(strippingNewline: true) else {
  exit(0)
}

tama = Tamagotchi(name: name)

print("\(name)   (age) health {bored} {food}   {poop}\n\n")

health()
blurb()
var count = 0

while alive() {
  print("? ", terminator: "")

  guard let input = readLine(strippingNewline: true) else {
    exit(0)
  }

  let split = input.components(separatedBy: " ")

  guard split.count <= 2 else {
    continue
  }

  let action = split[0]

  guard action == "feed" ||
          action == "play" ||
          action == "talk" ||
          action == "clean" ||
          action == "wait" else {
    continue
  }

  var reps = 1

  if split.count == 2, let r = Int(split[1]), r > 0 {
    reps = r
  }

  for _ in 0..<reps {
    switch action {
    case "feed":
      feed()
    case "play":
      play()
    case "talk":
      talk()
    case "clean":
      clean()
    case "wait":
      wait()
    case _:
      fatalError()
    }

    if action != "wait" {
      count += 1

      if count % 3 == 0 {
        wait()
      }
    }
  }

  health()
}
