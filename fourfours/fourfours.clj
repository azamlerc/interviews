;; Four fours is a mathematical puzzle. The goal is to find a mathematical expression for every whole number from 1 to 100, using only common mathematical symbols and the number four four times.

;; Problem: https://en.wikipedia.org/wiki/Four_fours
;; Playground: https://andrewzc.net/fourfours/

;; In this case, we will start with the initial values 4, .4, √4 and 4! and combine them using the operations addition, subtraction, multiplication and division.

(defn round [d] (Double/parseDouble (format "%.6f" d)))

(defn combine [fa fb]
  (->> (for [a fa b fb] 
    [(+ a b) (- a b) (- b a) (* a b)
      (if (zero? b) [] (round (/ a b)))
      (if (zero? a) [] (round (/ b a)))])
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
  (println "1 four" f1) (println)
  (println "2 fours" f2) (println)
  (println "3 fours" f3) (println)
  (println "4 fours" found) (println)
  (println "missing" missing) (println)
  (if (= missing [73 77 81 87 93 99]) (println "Success!")))

(four-fours)
