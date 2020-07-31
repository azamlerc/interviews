# This program implements the Solitaire encryption algorithm
# as described in the appendix of the book Cryptonomicon by
# Neal Stephenson:

# https://www.schneier.com/academic/solitaire/

# Solitaire is a cypher that can be performed using a deck of
# playing cards. If two people each have a deck of playing
# cards in the same order, each can generate a keystream that
# can be used to encypher and decypher a message.

from enum import Enum
import string
import textwrap

def charValue(value):
    while value < 1:
        value += 26
    value = (value - 1) % 26 + 1
    return chr(value + 64)

def intValue(char): return ord(char) - 64
def plus(values): return charValue(intValue(values[0]) + intValue(values[1]))
def minus(values): return charValue(intValue(values[0]) - intValue(values[1]))
def split(word): return [char for char in word]
def add(a, b): return "".join(map(plus, zip(split(a), split(b))))
def subtract(a, b): return "".join(map(minus, zip(split(a), split(b))))
def blocks(s): return " ".join(textwrap.wrap(s, 5))

class Suit(Enum):
    CLUBS = 1
    DIAMONDS = 2
    HEARTS = 3
    SPADES = 4
    JOKER = 5

class Card:
    def __init__(self, suit, rank):
        self.suit = suit
        self.rank = rank

    def __str__(self):
        return self.rank_str() + self.suit_str()

    def rank_str(self):
        if self.suit == Suit.JOKER:
            return "A" if self.rank == 1 else "B"
        else:
            letters = {1: "A", 11: "J", 12: "Q", 13: "K"}
            return letters.get(self.rank, str(self.rank))

    def suit_str(self):
        suits = {Suit.CLUBS: "♣️",
                 Suit.DIAMONDS: "♦️",
                 Suit.HEARTS: "♥️",
                 Suit.SPADES: "♠️",
                 Suit.JOKER: "🃏"}
        return suits.get(self.suit)

    def number(self): # subuptimal because we have to calcualte all of these
        suits = {Suit.CLUBS: self.rank,
                 Suit.DIAMONDS: self.rank + 13,
                 Suit.HEARTS: self.rank + 26,
                 Suit.SPADES: self.rank + 39,
                 Suit.JOKER: 53}
        return suits.get(self.suit)

    def letter(self):
        suits = {Suit.CLUBS: charValue(self.rank),
                 Suit.DIAMONDS: charValue(self.rank + 13),
                 Suit.HEARTS: charValue(self.rank),
                 Suit.SPADES: charValue(self.rank + 13),
                 Suit.JOKER: None}
        return suits.get(self.suit)

class Deck:
    def __init__(self):
        self.cards = []
        for suit in [Suit.CLUBS, Suit.DIAMONDS, Suit.HEARTS, Suit.SPADES]:
            for rank in range(1, 14):
                self.cards.append(Card(suit, rank))
        self.jokerA = Card(Suit.JOKER, 1)
        self.jokerB = Card(Suit.JOKER, 2)
        self.cards.append(self.jokerA)
        self.cards.append(self.jokerB)

    def __str__(self):
        return ", ".join(map(lambda c: str(c), self.cards))

    def move(self, card, downBy):
        index = self.cards.index(card)
        del self.cards[index]
        newIndex = (index + downBy - 1) % len(self.cards) + 1
        self.cards.insert(newIndex, card)

    def cut(self, count):
        self.cards = (self.cards[count:53] +
                      self.cards[0:count] +
                      self.cards[53:54])

    def tripleCut(self, card1, card2):
        index1 = self.cards.index(card1)
        index2 = self.cards.index(card2)
        if index1 > index2:
            index1, index2 = index2, index1
        self.cards = (self.cards[(index2 + 1):54] +
                      self.cards[index1:(index2 + 1)] +
                      self.cards[0:index1])

class Generator:
    def keystream(self, length):
        stream = ""
        while len(stream) < length:
            stream += self.more()
        return stream[0:length]

    def more(self):
        return "A"

class Example(Generator):
    def more(self):
        return "KDWUPONOWT"

class Solitaire(Generator):
    def __init__(self, passphrase):
        self.deck = Deck()

        if passphrase is not None:
            for letter in split(passphrase.upper()):
                self.shuffle()
                self.deck.cut(intValue(letter))

    def more(self):
        self.shuffle()
        number = self.deck.cards[0].number()
        letter = self.deck.cards[number].letter()
        return letter if letter is not None else self.more()

    def shuffle(self):
        self.deck.move(self.deck.jokerA, 1)
        self.deck.move(self.deck.jokerB, 2)
        self.deck.tripleCut(self.deck.jokerA, self.deck.jokerB)
        self.deck.cut(self.deck.cards[-1].number())

def encryptable(value):
    value = ''.join(c for c in value.upper() if c.isalpha())
    while len(value) % 5 > 0:
        value += "X"
    return value

class Crypt:
    def __init__(self, generator):
        self.generator = generator

    def encrypt(self, value):
        value = encryptable(value)
        keystream = self.generator.keystream(len(value))
        return add(value, keystream)

    def decrypt(self, value):
        value = value.replace(" ", "")
        keystream = self.generator.keystream(len(value))
        return subtract(value, keystream)

class Test:
    def __init__(self, plain, pretty, encrypted, generator):
        self.plain = plain
        self.pretty = pretty
        self.encrypted = encrypted
        self.generator = generator

    def check(self, kind, a, b):
        print(kind + ": " + (
            "pass (" + a + ")" if a == b else
            "fail (" + a + " / " + b + ")"))

    def run(self):
        crypt = Crypt(self.generator())
        self.check("pretty ",
            blocks(encryptable(self.plain)), self.pretty)
        self.check("encrypt",
            blocks(crypt.encrypt(self.plain)), self.encrypted)
        crypt = Crypt(self.generator())
        self.check("decrypt",
            blocks(crypt.decrypt(self.encrypted)), self.pretty)

tests = [Test("Hello!", "HELLO", "IFMMP",
    lambda: Generator()),
  Test("Do not use PC!", "DONOT USEPC", "OSKJJ JGTMW",
    lambda: Example()),
  Test("Aaaaaaaaaa!", "AAAAA AAAAA", "EXKYI ZSGEH",
    lambda: Solitaire(None)),
  Test("Aaaaaaaaaaaaaaa!", "AAAAA AAAAA AAAAA", "ITHZU JIWGR FARMW",
    lambda: Solitaire("FOO")),
  Test("Solitaire!", "SOLIT AIREX", "KIRAK SFJAN",
    lambda: Solitaire("CRYPTONOMICON"))]

for test in tests:
    test.run()