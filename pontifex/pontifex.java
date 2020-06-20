// This program implements the Solitaire encryption algorithm 
// as described in the appendix of the book Cryptonomicon by 
// Neal Stephenson:

// https://www.schneier.com/academic/solitaire/

// Solitaire is a cypher that can be performed using a deck of 
// playing cards. If two people each have a deck of playing 
// cards in the same order, each can generate a keystream that 
// can be used to encypher and decypher a message.

import java.io.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

class Pontifex {
  public static int intValue(char c) {
    return ((int) c) - 64;
  }
  
  public static char charValue(int i) {
    while (i < 1) i += 26;
    i = (i - 1) % 26 + 1;
    return (char)(i + 64);
  }
  
  public static char addChars(char a, char b) {
    return charValue(intValue(a) + intValue(b));
  }

  public static char subtractChars(char a, char b) {
    return charValue(intValue(a) - intValue(b));
  }
  
  // TODO: return a string that is the result of
  // adding the characters in the two strings
  public static String addStrings(String a, String b) {
    int length = Math.min(a.length(), b.length());
    char[] arrayA = a.toCharArray();
    char[] arrayB = b.toCharArray();
    char[] result = new char[length];
    
    for (int i = 0; i < length; i++) {
      result[i] = addChars(arrayA[i], arrayB[i]);
    }
    return new String(result);
  }
  
  // TODO: return a string that is the result of
  // subtracting the characters in the two strings
  public static String subtractStrings(String a, String b) {
    int length = Math.min(a.length(), b.length());
    char[] arrayA = a.toCharArray();
    char[] arrayB = b.toCharArray();
    char[] result = new char[length];
    
    for (int i = 0; i < length; i++) {
      result[i] = subtractChars(arrayA[i], arrayB[i]);
    }
    return new String(result);
  }

  public static String blocks(String string) {
    ArrayList<String> split = new ArrayList<>();
    for (int i = 0; i <= string.length() / 5; i++) {
      split.add(string.substring(i * 5, 
        Math.min((i + 1) * 5, string.length())));
    }
    return String.join(" ", split).trim();
  }
}

enum Suit {
  CLUBS,
  DIAMONDS,
  HEARTS,
  SPADES,
  JOKER;

  public String toString() {
    switch (this) {
      case CLUBS: return "♣️";
      case DIAMONDS: return "♦️";
      case HEARTS: return "♥️";
      case SPADES: return "♠️";
      default: return "🃏";
    }
  }  
}

class Card {
  Suit suit;
  int rank;
  
  Card(Suit suit, int rank) {
    this.suit = suit;
    this.rank = rank;
  }

  public String toString() {
    return rankString() + suit.toString();
  }

  public String rankString() {
    if (suit == Suit.JOKER) {
      return rank == 1 ? "A" : "B";
    } else {
      switch (rank) {
        case 1: return "A";
        case 11: return "J";
        case 12: return "Q";
        case 13: return "K";
        default: return String.valueOf(rank);
      }
    }
  }

  public int number() {
    switch (suit) {
      case CLUBS: return rank;
      case DIAMONDS: return rank + 13;
      case HEARTS: return rank + 26;
      case SPADES: return rank + 39;
      default: return 53;
    }
  }

  public char letter() {
    switch (suit) {
      case CLUBS:
      case HEARTS: return Pontifex.charValue(rank);
      case DIAMONDS:
      case SPADES: return Pontifex.charValue(rank + 13);
      default: return 0;
    }
  }
}

class Deck {
  ArrayList<Card> cards;
  Card jokerA;
  Card jokerB;

  Deck() {
    this.cards = new ArrayList<>();
    for (Suit suit : Suit.values()) {
      if (suit == Suit.JOKER) continue;
      for (int rank = 1; rank <= 13; rank++) {
        this.cards.add(new Card(suit, rank));
      }
    }
    this.jokerA = new Card(Suit.JOKER, 1);
    this.jokerB = new Card(Suit.JOKER, 2);
    this.cards.add(jokerA);
    this.cards.add(jokerB);
  }

  // TODO: find the given card and move it towards the end
  // of the deck by the given number of slots. If the card
  // is at the bottom and you're moving it down by one, then
  // it should be moved to just after the first card.
  public void move(Card card, int downBy) {
    int index = cards.indexOf(card);
    cards.remove(index);
    int newIndex = (index + downBy - 1) % cards.size() + 1;
    cards.add(newIndex, card);
  }

  private void reorder(List<Card> a, List<Card> b, List<Card> c) {
    ArrayList<Card> newCards = new ArrayList<>();
    newCards.addAll(a);
    newCards.addAll(b);
    newCards.addAll(c);
    this.cards = newCards;
  }
  
  // TODO: cut the deck by switching the given number of 
  // of cards at the beginning with the rest of the cards. 
  // The last card in the deck should remain at the end.
  public void cut(int count) {
    reorder(cards.subList(count, 53),
      cards.subList(0, count),
      cards.subList(53, 54));
  }

  // TODO: find the two jokers, and swap the cards before
  // the first one with the cards after the second one.
  // The jokers and the cards between them should remain
  // where they are.
  public void tripleCut(Card card1, Card card2) {
    int index1 = cards.indexOf(card1);
    int index2 = cards.indexOf(card2);
    if (index1 > index2) {
      int temp = index1;
      index1 = index2;
      index2 = temp;
    }
    reorder(cards.subList(index2 + 1, cards.size()),
      cards.subList(index1, index2 + 1),
      cards.subList(0, index1));
  }
}

class Generator {
  public String keystream(int length) {
    String string = "";
    while (string.length() < length) { 
      string += next();
    }
    if (string.length() > length) {
      string = string.substring(0, length);
    }
    return string;
  }

  public String next() {
    return "A";
  }
}

class Example extends Generator {
  @Override
  public String next() {
    return "KDWUPONOWT";
  }
}

class Solitaire extends Generator {
  Deck deck;

  Solitaire(String passphrase) {
    this.deck = new Deck();
    
    if (passphrase != null) {
      char[] phrase = passphrase.toUpperCase().toCharArray();
      for (int i = 0; i < phrase.length; i++) {
        shuffle();
        deck.cut(Pontifex.intValue(phrase[i]));
      }
    }
  }

  @Override 
  public String next() {
    shuffle();
    int number = deck.cards.get(0).number();
    char letter = deck.cards.get(number).letter();
    if (letter == 0) {
      return next();
    }
    return String.valueOf(letter);
  }

  public void shuffle() {
    deck.move(deck.jokerA, 1);
    deck.move(deck.jokerB, 2);
    deck.tripleCut(deck.jokerA, deck.jokerB);
    deck.cut(deck.cards.get(53).number());
  }
}

class Crypt {
  Generator generator;

  Crypt(Generator generator) {
    this.generator = generator;
  }
  
  public String encrypt(String string) {
    String value = Crypt.encryptable(string);
    String keystream = generator.keystream(value.length());
    return Pontifex.addStrings(value, keystream);
  }

  public String decrypt(String string) {
    String value = string.replaceAll(" ", "");
    String keystream = generator.keystream(value.length());
    return Pontifex.subtractStrings(value, keystream);
  }

  public static String encryptable(String string) {
    String value = string.toUpperCase();
    value = String.join("", Arrays.asList(value.split("\\W+")));
    while (value.length() % 5 > 0) {
      value += "X";
    }
    return value;
  }
}

interface GeneratorType {
  Generator make();
}

class Test {
  String plain;
  String pretty;
  String encrypted;
  GeneratorType generator;
  
  Test(String plain,
       String pretty,
       String encrypted,
       GeneratorType generator) {
    this.plain = plain;
    this.pretty = pretty;
    this.encrypted = encrypted;
    this.generator = generator;
  }

  public void test(String type, String a, String b) {
    System.out.println(type + ": " + (a.equals(b) ? 
      "pass (" + a + ")" : 
      "fail (" + a + " / " + b + ")"));
  }
  
  public void run() {
    Crypt crypt = new Crypt(generator.make());
    test("pretty ", Pontifex.blocks(Crypt.encryptable(plain)), pretty);
    test("encrypt", Pontifex.blocks(crypt.encrypt(plain)), encrypted);
    crypt = new Crypt(generator.make());
    test("decrypt", Pontifex.blocks(crypt.decrypt(encrypted)), pretty);
  }
}

class Solution {
  public static void main(String[] args) {
    ArrayList<Test> tests = new ArrayList<Test>(Arrays.asList(
      new Test("Hello!", 
        "HELLO", 
        "IFMMP", 
        () -> new Generator()),
      new Test("Do not use PC!", 
        "DONOT USEPC", 
        "OSKJJ JGTMW", 
        () -> new Example()),
      new Test("Aaaaaaaaaa!", 
        "AAAAA AAAAA", 
        "EXKYI ZSGEH",
        () -> new Solitaire(null)),
      new Test("Aaaaaaaaaaaaaaa!", 
        "AAAAA AAAAA AAAAA", 
        "ITHZU JIWGR FARMW", 
        () -> new Solitaire("FOO")),
      new Test("Solitaire!", 
        "SOLIT AIREX", 
        "KIRAK SFJAN", 
        () -> new Solitaire("CRYPTONOMICON"))
    ));
    
    tests.stream().forEach(Test::run);
  }
}
