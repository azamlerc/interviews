// This program implements the Solitaire encryption algorithm 
// as described in the appendix of the book Cryptonomicon by 
// Neal Stephenson:

// https://www.schneier.com/academic/solitaire/

// Solitaire is a cypher that can be performed using a deck of 
// playing cards. If two people each have a deck of playing 
// cards in the same order, each can generate a keystream that 
// can be used to encypher and decypher a message.

import Foundation

extension Character {
  func intValue() -> Int {
    return Int(self.asciiValue ?? 64) - 64
  }

  static func + (a: Character, b: Character) -> Character {
    return (a.intValue() + b.intValue()).charValue()
  }

  static func - (a: Character, b: Character) -> Character {
    return (a.intValue() - b.intValue()).charValue()
  }
}

extension Int {
  func charValue() -> Character {
    var value = self
    while value < 1 {
      value += 26
    }
    value = (value - 1) % 26 + 1
    return Character(UnicodeScalar(value + 64)!)
  }
}

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}

extension String {
  func blocks() -> String {
    let chunks = Array(self).chunked(into: 5).map { String($0) }
    return chunks.joined(separator: " ")
  }
}

enum Suit: String {
  case clubs = "♣️"
  case diamonds = "♦️"
  case hearts = "♥️"
  case spades = "♠️"
  case joker = "🃏"

  static var all: [Suit] {
    return [.clubs, .diamonds, .hearts, .spades]
  }
}

class Card: Equatable, CustomStringConvertible {
  let suit: Suit
  let rank: Int

  init(suit: Suit, rank: Int) {
    self.suit = suit
    self.rank = rank
  }

  static func == (a: Card, b: Card) -> Bool {
    return a.rank == b.rank && a.suit == b.suit
  }

  var description: String {
    return "\(self.rankString)\(self.suit.rawValue)"
  }

  var rankString: String {
    if suit == .joker {
      return rank == 1 ? "A" : "B"
    } else {
      switch rank {
      case 1: return "A"
      case 11: return "J"
      case 12: return "Q"
      case 13: return "K"
      default: return "\(rank)"
      }
    }
  }

  var number: Int {
    switch suit {
    case .clubs: return rank
    case .diamonds: return rank + 13
    case .hearts: return rank + 26
    case .spades: return rank + 39
    case .joker: return 53
    }
  }

  var letter: Character? {
    switch suit {
    case .clubs, .hearts: return rank.charValue()
    case .diamonds, .spades: return (rank + 13).charValue()
    case .joker: return nil
    }
  }
}

class Deck {
  var cards = [Card]()
  let jokerA: Card
  let jokerB: Card

  init() {
    for suit in Suit.all {
      for rank in 1...13 {
        cards.append(Card(suit: suit, rank: rank))
      }
    }
    self.jokerA = Card(suit: .joker, rank: 1)
    self.jokerB = Card(suit: .joker, rank: 2)
    cards.append(contentsOf: [jokerA, jokerB])
  }

  func indexOf(card: Card) -> Int {
    return cards.firstIndex(of: card)!
  }

  func move(card: Card, downBy: Int) {
    let index = indexOf(card: card)
    cards.remove(at: index)
    let newIndex = (index + downBy - 1) % cards.count + 1
    cards.insert(card, at: newIndex)
  }

  func cut(count: Int) {
    cards = Array([cards[count..<53],
             cards[0..<count],
             cards[53...53]].joined())
  }

  func tripleCut(card1: Card, card2: Card) {
    var index1 = indexOf(card: card1)
    var index2 = indexOf(card: card2)
    if index1 > index2 {
      (index1, index2) = (index2, index1)
    }
    cards = Array([cards[(index2 + 1)..<cards.count],
             cards[index1...index2],
             cards[0..<index1]].joined())
  }
}

class Generator {
  func keystream(length: Int) -> String {
    var stream = ""
    while stream.count < length { stream += next() }
    return String(stream.prefix(length))
  }

  func next() -> String {
    return "A"
  }
}

class Example: Generator {
  override func next() -> String {
    return "KDWUPONOWT"
  }
}

class Solitaire: Generator {
  let deck = Deck()

  init(passphrase: String?) {
    super.init()

    if let pass = passphrase {
      for letter in pass.uppercased() {
        shuffle()
        deck.cut(count: letter.intValue())
      }
    }
  }

  override func next() -> String {
    shuffle()
    let number = deck.cards.first!.number
    guard let letter = deck.cards[number].letter else {
      return next()
    }
    return String(letter)
  }

  func shuffle() {
    deck.move(card: deck.jokerA, downBy: 1)
    deck.move(card: deck.jokerB, downBy: 2)
    deck.tripleCut(card1: deck.jokerA, card2: deck.jokerB)
    deck.cut(count: deck.cards.last!.number)
  }
}

class Crypt {
  var generator: Generator

  init(generator: Generator) {
    self.generator = generator
  }
  
  func encrypt(_ string: String) -> String {
    let value = Crypt.encryptable(string)
    let keystream = generator.keystream(length: value.count)
    return String(zip(value, keystream).map(+))
  }

  func decrypt(_ string: String) -> String {
    let value = string.replacingOccurrences(of: " ", with: "")
    let keystream = generator.keystream(length: value.count)
    return String(zip(value, keystream).map(-))
  }

  static func encryptable(_ string: String) -> String {
    var value = string.uppercased()
    value = value.components(separatedBy: CharacterSet.letters.inverted)
      .joined(separator: "")
    while value.count % 5 > 0 {
      value += "X"
    }
    return value
  }
}

class Test {
  let plain: String
  let pretty: String
  let encrypted: String
  let generator: () -> Generator
  
  init(plain: String, 
       pretty: String, 
       encrypted: String, 
       generator: @escaping () -> Generator) {
    self.plain = plain
    self.pretty = pretty
    self.encrypted = encrypted
    self.generator = generator
  }

  func assert(type: String, _ a: String, _ b: String) {
    print("\(type): \(a == b ? "pass" : "fail") (\(a)\(a != b ? " / " + b : ""))")
  }
  
  func run() {
    var crypt = Crypt(generator: generator())
    assert(type: "pretty ", Crypt.encryptable(plain).blocks(), pretty)
    assert(type: "encrypt", crypt.encrypt(plain).blocks(), encrypted)
    crypt = Crypt(generator: generator())
    assert(type: "decrypt", crypt.decrypt(encrypted).blocks(), pretty)
  }
}

let tests = [
  Test(plain: "Hello!", 
       pretty: "HELLO", 
       encrypted: "IFMMP", 
       generator: { return Generator() }),
  Test(plain: "Do not use PC!", 
       pretty: "DONOT USEPC", 
       encrypted: "OSKJJ JGTMW", 
       generator: { return Example() }),
  Test(plain: "Aaaaaaaaaa!", 
       pretty: "AAAAA AAAAA", 
       encrypted: "EXKYI ZSGEH",
       generator: { return Solitaire(passphrase: nil) }),
  Test(plain: "Aaaaaaaaaaaaaaa!", 
       pretty: "AAAAA AAAAA AAAAA", 
       encrypted: "ITHZU JIWGR FARMW", 
       generator: { return Solitaire(passphrase: "FOO") }),
  Test(plain: "Solitaire!", 
       pretty: "SOLIT AIREX", 
       encrypted: "KIRAK SFJAN", 
       generator: { return Solitaire(passphrase: "CRYPTONOMICON") })
]

tests.forEach { test in test.run()}
