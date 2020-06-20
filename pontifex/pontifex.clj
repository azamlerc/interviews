;; This program implements the Solitaire encryption algorithm
;; as described in the appendix of the book Cryptonomicon by
;; Neal Stephenson:

;; https://www.schneier.com/academic/solitaire/

;; Solitaire is a cypher that can be performed using a deck of
;; playing cards. If two people each have a deck of playing
;; cards in the same order, each can generate a keystream that
;; can be used to encypher and decypher a message.

;; Basic Functions

(defn blocks [string] (clojure.string/join " "
  (map #(apply str %1) (partition 5 string))))

(defn modulo [value base] (if (< value 1)
  (modulo (+ value 26) base)
  (+ (mod (- value 1) base) 1)))

(defn letter [number] (char (+ (modulo number 26) 64)))
(defn number [letter] (- (int letter) 64))
(defn addLetters [a b] (letter (+ (number a) (number b))))
(defn subtractLetters [a b] (letter (- (number a) (number b))))
(defn addStrings [a b] (apply str (map addLetters a b)))
(defn subtractStrings [a b] (apply str (map subtractLetters a b)))

(defn numbersToWords [string] (clojure.string/replace string #"0|1|2|3|4|5|6|7|8|9"
  {"0" "ZERO" "1" "ONE" "2" "TWO" "3" "THREE" "4" "FOUR"
   "5" "FIVE" "6" "SIX" "7" "SEVEN" "8" "EIGHT" "9" "NINE"}))

(defn xPad [string] (if (> (mod (count string) 5) 0)
  (xPad (str string "X")) string))

;; Crypt

(defn pretty [string] (->> string
  (numbersToWords)
  (clojure.string/upper-case)
  (filter #(Character/isLetter %))
  (apply str)
  (xPad)))

(defn aaaaa [length] (apply str (repeat length "A")))
(defn example [length] (subs (apply str (repeat (int (Math/ceil (/ length 10))) "KDWUPONOWT")) 0 length))

(defn encrypt [plain generator] (def string (pretty plain))
  (addStrings string (generator (count string))))
(defn decrypt [encrypted generator]
  (subtractStrings encrypted (generator (count encrypted))))

;; Deck

(def suits [:clubs :diamonds :hearts :spades])
(def jokerA [1 :joker])
(def jokerB [2 :joker])

(defn makeDeck [] (concat
  (for [suit suits number (range 1 14)] [number suit])
  [jokerA jokerB]))

(defn cardNumber [card] (let [rank (first card) suit (last card)]
  (case suit
  :clubs rank
  :diamonds (+ rank 13)
  :hearts (+ rank 26)
  :spades (+ rank 39)
  :joker 53)))

(defn cardLetter [card] (let [rank (first card) suit (last card)]
  (case suit
  :clubs (letter rank)
  :diamonds (letter (+ rank 13))
  :hearts (letter rank)
  :spades (letter (+ rank 13))
  :joker nil)))

(defn insert [array index item] (let [coll (vec array)]
  (concat (conj (subvec coll 0 index) item) (subvec coll index))))
(defn removeAt [array index] (let [coll (vec array)]
  (concat (subvec coll 0 index) (subvec coll (inc index)))))

(defn moveTo [card newIndex deck] (let [
  oldIndex (.indexOf deck card)
  tempDeck (removeAt deck oldIndex)]
  (insert tempDeck newIndex card)))

(defn moveDown [card down deck] (let [
  oldIndex (.indexOf deck card)
  tempDeck (removeAt deck oldIndex)
  newIndex (+ (mod (- (+ oldIndex down) 1) 53) 1)]
  (insert tempDeck newIndex card)))

(defn cut [index deck] (let [d (vec deck)]
  (concat (subvec d index 53)
          (subvec d 0 index)
          (subvec d 53 54))))

(defn tripleCut [cardA cardB deck] (let [
  d (vec deck)
  indexA (.indexOf deck cardA)
  indexB (.indexOf deck cardB)
  index1 (min indexA indexB)
  index2 (max indexA indexB)]
  (concat (subvec d (inc index2) 54)
          (subvec d index1 (inc index2))
          (subvec d 0 index1))))

(defn play [deck] (def shuffled (->> deck
  (moveDown jokerA 1)
  (moveDown jokerB 2)
  (tripleCut jokerA jokerB)))
  (cut (cardNumber (last shuffled)) shuffled))

(defn keystream [length string deck] (let [
  newDeck (play deck)
  number (cardNumber (first newDeck))
  letter (cardLetter (nth newDeck number))]
  (if (nil? letter)
    (keystream length string newDeck)
    (if (> length 0)
      (keystream (dec length) (str string letter) newDeck)
      string))))

(defn keyLetter [deck letter] (cut (number letter) (play deck)))
(defn keyDeck [phrase deck] (reduce keyLetter deck phrase))
(defn solitaire [length, phrase] (keystream length "" (keyDeck phrase (makeDeck))))

(def tests [
  {:plain "Hello!"
   :pretty "HELLO"
   :encrypted "IFMMP"
   :generator aaaaa}
  {:plain "Do not use PC!"
   :pretty "DONOT USEPC"
   :encrypted "OSKJJ JGTMW"
   :generator example}
  {:plain "Aaaaaaaaaa!"
   :pretty "AAAAA AAAAA"
   :encrypted "EXKYI ZSGEH"
   :generator #(solitaire %1 "")}
  {:plain "Aaaaaaaaaaaaaaa!"
   :pretty "AAAAA AAAAA AAAAA"
   :encrypted "ITHZU JIWGR FARMW"
   :generator #(solitaire %1 "FOO")}
  {:plain "Solitaire!"
   :pretty "SOLIT AIREX"
   :encrypted "KIRAK SFJAN"
   :generator #(solitaire %1 "CRYPTONOMICON")}])

(doseq [item tests]
  (assert (= (blocks (pretty (:plain item)))
             (:pretty item)) (str "pretty " (:plain item)))
  (assert (= (blocks (encrypt (:plain item) (:generator item)))
             (:encrypted item)) (str "encrypted " (:plain item)))
  (assert (= (blocks (decrypt (encrypt (:plain item)
               (:generator item)) (:generator item)))
             (:pretty item)) (str "decrypted " (:plain item))))

(println "All tests passed!")
