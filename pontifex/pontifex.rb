# This program implements the Solitaire encryption algorithm 
# as described in the appendix of the book Cryptonomicon by 
# Neal Stephenson:

# https://www.schneier.com/academic/solitaire/

# Solitaire is a cypher that can be performed using a deck of 
# playing cards. If two people each have a deck of playing 
# cards in the same order, each can generate a keystream that 
# can be used to encypher and decypher a message.

class Integer
  def charValue() 
    value = self
    while value < 1
      value += 26
    end
    value = (value - 1) % 26 + 1
    return (value + 64).chr
  end
end

class String
  def intValue() 
    return self.ord - 64
  end
  
  def plus(c)
    return (self.intValue + c.intValue).charValue
  end
  
  def minus(c)
    return (self.intValue - c.intValue).charValue
  end
  
  def add(s)
    return self.split("").zip(s.split(""))
      .map { |pair| pair[0].plus(pair[1]) }
      .join
  end
  
  def subtract(s)
    return self.split("").zip(s.split(""))
      .map { |pair| pair[0].minus(pair[1]) }
      .join
  end
  
  def blocks() 
    return self.scan(/.{5}/).join(" ")
  end
end

class Card
  attr_accessor :suit
  attr_accessor :rank
  
  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end
  
  def to_s
    return rank_str() + suit_str()
  end  

  def rank_str()
    if suit == :joker
      return rank == 1 ? "A" : "B"
    else
      case rank
      when 1
       return "A"
      when 11
        return "J"
      when 12
        return "Q"
      when 13
        return "K"
      else
        return rank.to_s
      end
    end
  end
    
  def suit_str()
    case suit
    when :clubs
      return "♣️"
    when :diamonds
      return "♦️"
    when :hearts
      return "♥️"
    when :spades
      return "♠️"
    else
      return "🃏"
    end
  end

  def number() 
    case suit
    when :clubs
      return rank
    when :diamonds
      return rank + 13
    when :hearts
      return rank + 26
    when :spades
      return rank + 39
    else 
      return 53
    end
  end

  def letter
    case suit
    when :clubs, :hearts
      return rank.charValue
    when :diamonds, :spades
      return (rank + 13).charValue
    when :joker
      return nil
    end
  end
end 
  
class Deck
  attr_accessor :cards
  attr_accessor :jokerA
  attr_accessor :jokerB

  def initialize()
    @cards = []
    [:clubs, :diamonds, :hearts, :spades].each do |suit|
      13.times do |rank|
        cards.push(Card.new(suit, rank + 1))
      end
    end
    @jokerA = Card.new(:joker, 1)
    @jokerB = Card.new(:joker, 2)
    cards.push(jokerA)
    cards.push(jokerB)
  end
  
  def move(card, downBy) 
    index = cards.index(card)
    cards.delete(card)
    newIndex = (index + downBy - 1) % cards.count + 1
    cards.insert(newIndex, card)
  end
  
  def cut(count)
    @cards = cards[count...53] + 
             cards[0...count] +
             cards[53...54]
  end

  def tripleCut(card1, card2)
    index1 = cards.index(card1)
    index2 = cards.index(card2)
    if index1 > index2
      index1, index2 = index2, index1
    end
    @cards = cards[(index2 + 1)...cards.count] + 
             cards[index1...(index2 + 1)] +
             cards[0, index1]
    end
end 

class Generator
  def keystream(length)
    stream = ""
    while stream.length < length
      stream += more()
    end
    return stream[0..(length - 1)]
  end
  
  def more() 
    return "A"
  end  
end

class Example < Generator
  def more() 
    return "KDWUPONOWT"
  end  
end

class Solitaire < Generator
  attr_accessor :deck
  
  def initialize(passphrase)
    @deck = Deck.new
    
    if passphrase != nil 
      passphrase.upcase.split("").each do |letter|
        shuffle()
        deck.cut(letter.intValue)
      end
    end
  end
  
  def more() 
    shuffle()
    number = deck.cards.first.number
    letter = deck.cards[number].letter
    if letter == nil 
      return more()
    end
    return letter
  end

  def shuffle()
    deck.move(deck.jokerA, 1)
    deck.move(deck.jokerB, 2)
    deck.tripleCut(deck.jokerA, deck.jokerB)
    deck.cut(deck.cards.last.number)
  end
end

class Crypt
  attr_accessor :generator
  
  def initialize(generator)
    @generator = generator
  end
  
  def encrypt(string)
    value = Crypt.encryptable(string)
    keystream = generator.keystream(value.length)
    return value.add(keystream)
  end
  
  def decrypt(string)
    value = string.gsub(" ", "")
    keystream = generator.keystream(value.length)
    return value.subtract(keystream)
  end
  
  def self.encryptable(string)
    value = string.upcase.gsub(/[^A-Z]/i, '')
    while value.length % 5 > 0
      value += "X"
    end
    return value
  end
end

class Test
  attr_accessor :plain
  attr_accessor :pretty
  attr_accessor :encrypted
  attr_accessor :generator
  
  def initialize(plain, pretty, encrypted, generator)
    @plain = plain
    @pretty = pretty
    @encrypted = encrypted
    @generator = generator
  end

  def assert(type, a, b)
    puts type + ": " + (a == b ? 
      "pass (" + a + ")" : 
      "fail (" + a + " / " + b + ")")
  end
  
  def run()
    crypt = Crypt.new(generator.call)
    assert("pretty ", Crypt.encryptable(plain).blocks, pretty)
    assert("encrypt", crypt.encrypt(plain).blocks, encrypted)
    crypt = Crypt.new(generator.call)
    assert("decrypt", crypt.decrypt(encrypted).blocks, pretty)
  end
end

tests = [
  Test.new("Hello!", 
       "HELLO", 
       "IFMMP", 
       Proc.new { Generator.new }),
  Test.new("Do not use PC!", 
       "DONOT USEPC", 
       "OSKJJ JGTMW", 
       Proc.new { Example.new }),
  Test.new("Aaaaaaaaaa!", 
       "AAAAA AAAAA", 
       "EXKYI ZSGEH",
       Proc.new { Solitaire.new(nil) }),
  Test.new("Aaaaaaaaaaaaaaa!", 
       "AAAAA AAAAA AAAAA", 
       "ITHZU JIWGR FARMW", 
       Proc.new { Solitaire.new("FOO") }),
  Test.new("Solitaire!", 
       "SOLIT AIREX", 
       "KIRAK SFJAN", 
       Proc.new { Solitaire.new("CRYPTONOMICON") })
].each { |test| test.run }
