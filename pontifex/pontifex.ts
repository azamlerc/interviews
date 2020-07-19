// This program implements the Solitaire encryption algorithm
// as described in the appendix of the book Cryptonomicon by
// Neal Stephenson:

// https://www.schneier.com/academic/solitaire/

// Solitaire is a cypher that can be performed using a deck of
// playing cards. If two people each have a deck of playing
// cards in the same order, each can generate a keystream that
// can be used to encypher and decypher a message.

interface Card {
  rank: number;
  suit: string;
}

type Deck = Card[];

let modulo = (n: number): number => n < 1 ? modulo(n + 26) : (n - 1) % 26 + 1;
let charValue = (n: number): string => String.fromCharCode(modulo(n) + 64);
let numVal = (letter: string): number => letter.charCodeAt(0) - 64;
let range = (n: number): number[] => Array.from(new Array(n), (x,i) => i + 1);
let zipMap = (a, b, func) => a.map((x, i) => func(x, b[i]));
let squareMap = (a, b, func) => a.map((x) => b.map((y) => func(x, y)));
let addLetters = (a: string, b: string): string => charValue(numVal(a) + numVal(b));
let subLetters = (a: string, b: string): string => charValue(numVal(a) - numVal(b));
let addStrings = (a: string, b: string): string => zipMap([...a], [...b], addLetters).join("");
let subStrings = (a: string, b: string): string => zipMap([...a], [...b], subLetters).join("");
let xPad = (s: string): string => (s.length % 5) ? xPad(s + "X") : s;
let pretty = (s: string): string => xPad(s.toUpperCase().replace(/[^a-zA-Z]/g, ""));
let chunks = (s: string): string => s.match(/.{1,5}/g).join(" ");
let aaaaa = (n: number): string => "A".repeat(n);
let example = (n: number): string => "KDWUPONOWT".repeat(n / 10 + 1).substring(0, n);
let assert = (type: string, a: string, b: string) => console.log(`${type}: ${a === b ? "pass" :
    "fail"} (${a}${a !== b ? " / " + b : ""})`);
let flatten = (arrays: Card[][]): Card[] => arrays.reduce((result: Card[], array: Card[]) => result.concat(array), []);

// CRYPT

type generator = (n: number) => string;

function encrypt(string: string, generator: generator): string {
  let value = pretty(string);
  let keystream = generator(value.length);
  return addStrings(value, keystream);
}

function decrypt(string: string, generator: generator): string {
  let value = string.toUpperCase();
  let keystream = generator(value.length);
  return subStrings(value, keystream);
}

// DECK

let suits: string[] = ["♣️", "♦️", "♥️", "♠️"];
let jokerA: Card = {rank: 1, suit: "🃏"};
let jokerB: Card = {rank: 2, suit: "🃏"};
let newDeck = (): Deck => flatten(squareMap(suits, range(13), 
  (suit: string, rank: number): Card => ({rank, suit}))
  .concat([jokerA, jokerB]));

function cardNumber(card: Card): number {
  switch (card.suit) {
    case "♣️": return card.rank;
    case "♦️": return card.rank + 13;
    case "♥️": return card.rank + 26;
    case "♠️": return card.rank + 39;
    default: return 53;
  }
}

function cardLetter(card: Card): string {
  switch (card.suit) {
    case "♣️":
    case "♥️": return charValue(card.rank);
    case "♦️":
    case "♠️": return charValue(card.rank + 13);
    default: return null;
  }
}

function moveDown(deck: Deck, card: Card, by: number) {
    let index = deck.indexOf(card);
    deck.splice(index, 1);
    let newIndex = (index + by - 1) % deck.length + 1;
    deck.splice(newIndex, 0, card);
}

function cut(deck: Deck, count: number): Deck {
    return flatten([deck.slice(count, 53),
            deck.slice(0, count),
            deck.slice(53, 54)]);
}

function tripleCut(deck: Deck, card1: Card, card2: Card): Deck {
    let index1 = deck.indexOf(card1);
    let index2 = deck.indexOf(card2);
    if (index1 > index2) {
        [index1, index2] = [index2, index1];
    }
    return flatten([deck.slice(index2 + 1, 54),
            deck.slice(index1, index2 + 1),
            deck.slice(0, index1)]);
}

// SOLITAIRE

function shuffle(deck: Deck): Deck {
  moveDown(deck, jokerA, 1);
  moveDown(deck, jokerB, 2);
  deck = tripleCut(deck, jokerA, jokerB);
  return cut(deck, cardNumber(deck[53]));
}

let keyLetter = (deck: Deck, letter: string): Deck => cut(shuffle(deck), numVal(letter));
let keyDeck = (deck: Deck, phrase: string): Deck => [...phrase].reduce(keyLetter, deck);

function solitaire(n: number, phrase: string = null): string {
  let deck = newDeck();
  if (phrase) deck = keyDeck(deck, phrase);
  let result = "";
  while (result.length < n) {
    deck = shuffle(deck);
    let number = cardNumber(deck[0]);
    let letter = cardLetter(deck[number]);
    if (letter === null) continue;
    result += letter;
  }

  return result;
}

// TESTS

interface Test {
  plain: string;
  pretty: string;
  encrypted: string;
  generator: generator;
}

let tests: Test[] = [
  {plain: "Hello!",
   pretty: "HELLO",
   encrypted: "IFMMP",
   generator: aaaaa},
  {plain: "Do not use PC!",
   pretty: "DONOT USEPC",
   encrypted: "OSKJJ JGTMW",
   generator: example},
  {plain: "Aaaaaaaaaa!",
   pretty: "AAAAA AAAAA",
   encrypted: "EXKYI ZSGEH",
   generator: solitaire},
  {plain: "Aaaaaaaaaaaaaaa!",
   pretty: "AAAAA AAAAA AAAAA",
   encrypted: "ITHZU JIWGR FARMW",
   generator: (n) => solitaire(n, "FOO")},
  {plain: "Solitaire!",
   pretty: "SOLIT AIREX",
   encrypted: "KIRAK SFJAN",
   generator: (n) => solitaire(n, "CRYPTONOMICON")}
];

tests.forEach((t: Test) => {
  assert("pretty ", chunks(pretty(t.plain)), t.pretty);
  assert("encrypt", chunks(encrypt(t.plain, t.generator)), t.encrypted);
  assert("decrypt", chunks(decrypt(encrypt(t.plain, t.generator),
    t.generator)), t.pretty);
});
