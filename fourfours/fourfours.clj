;; Four fours is a mathematical puzzle. The goal is to find a mathematical expression for every whole number from 1 to 100, using only common mathematical symbols and the number four four times.

;; Problem: https://en.wikipedia.org/wiki/Four_fours
;; Playground: https://andrewzc.net/fourfours/

;; In this case, we will start with the initial values 4, .4, √4 and 4! and combine them using the operations addition, subtraction, multiplication and division.

(defn round [d] (Double/parseDouble (format "%.6f" d)))

(defn div [a b] (if (zero? b) [] (round (/ a b))))

(defn both-ways [op a b] [(op a b) (op b a)])

(defn combine [fa fb]
  (->> (for [a fa b fb op [+ - * div]] (both-ways op a b)) (flatten) (distinct) (sort)))

(defn four-fours []
  (let [
    f1 [0.4 2.0 4.0 24.0]
    f2 (combine f1 f1)
    f3 (combine f1 f2)
    f4 (set (concat (combine f1 f3) (combine f2 f2)))
    target (range 1 101)
    found (filter #(contains? f4 (double %)) target)
    missing (filter #(not (contains? (set found) %)) target)]
  (println
    "1 four" f1 "\n\n"
    "2 fours" f2 "\n\n"
    "3 fours" f3 "\n\n"
    "4 fours" found "\n\n"
    "missing" missing "\n")
  (if (= missing [73 77 81 87 93 99]) (println "Success!"))))

(four-fours)
