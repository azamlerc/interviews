;; Four fours is a mathematical puzzle. The goal is to find a mathematical expression for every whole number from 1 to 100, using only common mathematical symbols and the number four four times.

;; Problem: https://en.wikipedia.org/wiki/Four_fours
;; Playground: https://andrewzc.net/fourfours/

;; In this case, we will start with the initial values 4, .4, √4 and 4! and combine them using the operations addition, subtraction, multiplication and division.

(defn round [d] (Double/parseDouble (format "%.6f" d)))

(defn combine [fa fb]
  (->> (for [a fa b fb] 
    [(+ a b) (- a b) (- b a) (* a b)
      (if (> b 0) (round (/ a b)) [])
      (if (> a 0) (round (/ b a)) [])])
  (flatten)
  (distinct)
  (sort)))
	
(defn four-fours []
  (def f1 [0.4 2.0 4.0 24.0])
  (def f2 (combine f1 f1))
  (def f3 (combine f1 f2))
  (def f4 (set (concat (combine f1 f3) (combine f2 f2))))
  (def found (filter #(contains? f4 (double %)) (range 1 101)))
  (def missing (filter #(not (contains? f4 (double %))) (range 1 101)))
  (prn "1 four" f1) (prn)
  (prn "2 fours" f2) (prn)
  (prn "3 fours" f3) (prn)
  (prn "4 fours" found) (prn)
  (prn "missing" missing) (prn)
  (if (= missing [73 77 81 87 93 99]) (prn "Success!")))

(four-fours)