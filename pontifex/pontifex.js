// This program implements the Solitaire encryption algorithm 
// as described in the appendix of the book Cryptonomicon by 
// Neal Stephenson:

// https://www.schneier.com/academic/solitaire/

// Solitaire is a cyper that can be performed using a deck of 
// playing cards. If two people each have a deck of playing 
// cards in the same order, each can generate a keystream that 
// can be used to encypher and decypher a message.

let modulo = (n) => n < 1 ? modulo(n + 26) : (n - 1) % 26 + 1;
let charValue = (n) => String.fromCharCode(modulo(n) + 64);
let numVal = (letter) => letter.charCodeAt(0) - 64;
let range = (n) => Array.from(new Array(n), (x,i) => i + 1);
let zipMap = (a, b, func) => a.map((x, i) => func(x, b[i]));
let squareMap = (a, b, func) => a.map((x) => b.map((y) => func(x, y)));
let addLetters = (a, b) => charValue(numVal(a) + numVal(b));
let subLetters = (a, b) => charValue(numVal(a) - numVal(b));  
let addStrings = (a, b) => zipMap([...a], [...b], addLetters).join("");
let subStrings = (a, b) => zipMap([...a], [...b], subLetters).join("");
let xPad = (s) => (s.length % 5) ? xPad(s + "X") : s;
let pretty = (s) => xPad(s.toUpperCase().replace(/[^a-zA-Z]/g, ""));
let chunks = (s) => s.match(/.{1,5}/g).join(" ");
let aaaaa = (n) => "A".repeat(n);
let example = (n) => "KDWUPONOWT".repeat(n / 10 + 1).substring(0, n);
let assert = (type, a, b) => console.log(`${type}: ${a === b ? "pass" : 
    "fail"} (${a}${a !== b ? " / " + b : ""})`);

// CRYPT

function encrypt(string, generator) {
  let value = pretty(string);
  let keystream = generator(value.length);
  return addStrings(value, keystream);
}

function decrypt(string, generator) {
  let value = string.toUpperCase();
  let keystream = generator(value.length);
  return subStrings(value, keystream);
}

// DECK

let suits = ["♣️", "♦️", "♥️", "♠️"];
let jokerA = ["🃏", 1];
let jokerB = ["🃏", 2];
let newDeck = () => squareMap(suits, range(13), (a, b) => [b, a])
  .flat().concat([jokerA, jokerB]);

function cardNumber(card) {
  switch (card[1]) {
    case "♣️": return card[0];
    case "♦️": return card[0] + 13;
    case "♥️": return card[0] + 26;
    case "♠️": return card[0] + 39;
    default: return 53;
  }
}

function cardLetter(card) {
  switch (card[1]) {
    case "♣️":
    case "♥️": return charValue(card[0]);
    case "♦️":
    case "♠️": return charValue(card[0] + 13);
    default: return null;
  }
}

function moveTo(deck, card, index) {
    let oldIndex = deck.indexOf(card);
    deck.splice(index, 1);
    deck.splice(newIndex, 0, card);
}

function moveDown(deck, card, by) {
    let index = deck.indexOf(card);
    deck.splice(index, 1);
    let newIndex = (index + by - 1) % deck.length + 1;
    deck.splice(newIndex, 0, card);
}

function cut(deck, count) {
    return [deck.slice(count, 53),
            deck.slice(0, count),
            deck.slice(53, 54)].flat();
}

function tripleCut(deck, card1, card2) {
    let index1 = deck.indexOf(card1);
    let index2 = deck.indexOf(card2);
    if (index1 > index2) {
        [index1, index2] = [index2, index1];
    }
    return [deck.slice(index2 + 1, 54),
            deck.slice(index1, index2 + 1),
            deck.slice(0, index1)].flat();
}

// SOLITAIRE

function shuffle(deck) {
  moveDown(deck, jokerA, 1);
  moveDown(deck, jokerB, 2);
  deck = tripleCut(deck, jokerA, jokerB);
  return cut(deck, cardNumber(deck[53]));
}

let keyLetter = (deck, letter) => cut(shuffle(deck), numVal(letter));
let keyDeck = (deck, phrase) => [...phrase].reduce(keyLetter, deck);

function solitaire(n, phrase = null) {
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

let tests = [
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

tests.forEach((t, n) => {
  assert("pretty ", chunks(pretty(t.plain)), t.pretty);
  assert("encrypt", chunks(encrypt(t.plain, t.generator)), t.encrypted);
  assert("decrypt", chunks(decrypt(encrypt(t.plain, t.generator),
    t.generator)), t.pretty);
});
