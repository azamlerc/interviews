;; Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

;; Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as {blocks west of Ave A, blocks north of Houston}. For example, the coordinates for the Compass office are {5,14} because it is at the intersection of 5 Av and 14 St. 

;; Visualization:
;; https://andrewzc.net/subway.html

(def home [9 55])
(def compass [5 14])
(def avenue-block 0.17)
(def street-block 0.05)
(def walking-speed 3.0)
(def subway-speed 17.0)
(def entry-time 3.0)
(def dwell-time 0.5)
(def exit-time 1.0)

(def lines {
 "1" [[7 0] [7 4] [7 14] [7 18] [7 23] [7 28] [7 34] [7 42] [7 50] [8 59]]
 "2" [[7 14] [7 34] [7 42]]
 "4" [[4 14] [3.75 42] [3.5 59]]
 "6" [[3.5 0] [4 8] [4 14] [4 23] [4 28] [4 33] [3.75 42] [3.5 51] [3.5 59]]
 "A" [[6 4] [8 14] [8 34] [8 42] [8 59]]
 "C" [[6 4] [8 14] [8 23] [8 34] [8 42] [8 50] [8 59]]
 "D" [[3.5 0] [6 4] [6 34] [6 42] [6 47] [7 53] [8 59]]
 "F" [[2 0] [3.5 0] [6 4] [6 14] [6 23] [6 34] [6 42] [6 47] [6 57]]
 "L" [[1 14] [3 14] [4 14] [6 14] [8 14]]
 "M" [[3.5 0] [6 4] [6 14] [6 23] [6 34] [6 42] [6 47] [5 53] [3 53]]
 "Q" [[4 14] [6 34] [7 42] [7 57] [5 59]]
 "R" [[4 8] [4 14] [5 23] [5.5 28] [6 34] [7 42] [7 49] [7 57] [5 59]]
})

(def listings (list
 {:name "Alphabet City" :point [0 3]}
 {:name "Hudson Yards" :point [11 34]}
 {:name "Times Square" :point [7 42]}
 {:name "Chelsea" :point [9 22]}
 {:name "Tompkins Square" :point [0 10]}
 {:name "East Village" :point [2 7.5]}
 {:name "Washington Square" :point [5 6]}
 {:name "Empire State" :point [5 34]}
 {:name "Grand Central" :point [3.75 42]}
 {:name "Kips Bay" :point [1 33]}
 {:name "Hell's Kitchen" :point [9 55]}
))

(defn round [d] (Double/parseDouble (format "%.2f" d)))

(defn avenue-distance [p1 p2] 
  (-> (- (first p1) (first p2)) (Math/abs) (* avenue-block)))

(defn street-distance [p1 p2] 
  (-> (- (second p1) (second p2)) (Math/abs) (* street-block)))

(defn walking-time [p1 p2] 
  (def dx (avenue-distance p1 p2))
  (def dy (street-distance p1 p2))
  (-> (+ dx dy) (/ walking-speed) (* 60.0)))

(defn subway-time [p1 p2] 
  (def dx (avenue-distance p1 p2))
  (def dy (street-distance p1 p2))
  (-> (+ (* dx dx) (* dy dy)) (Math/sqrt) (/ subway-speed) (* 60.0)))

(defn subway-journey-time [line start end] 
  (def min-index (min start end))
  (def max-index (max start end)) 
  (def subway-times (for [i (range min-index max-index)]  
    (+ (subway-time (line i) (line (inc i))) dwell-time)))
  (- (+ entry-time (reduce + subway-times) exit-time) dwell-time))

(defn index-of-nearest-station [line point]
  (def times (map #(walking-time % point) line))
  (def indexed-times (map-indexed (fn [i t] [i t]) times))
  (first (reduce #(if (< (second %1) (second %2)) %1 %2) indexed-times)))

(defn calculate-itinerary [line-name home office]
  (def line (get lines line-name))
  (def start-index (index-of-nearest-station line home))
  (def end-index (index-of-nearest-station line office))
  (def start-station (line start-index))
  (def end-station (line end-index))
  (def walk1 (walking-time home start-station))
  (def train (subway-journey-time line start-index end-index))
  (def walk2 (walking-time end-station office))
  (def total-time (round (+ walk1 train walk2)))
  {:line line-name :start start-station :end end-station :time total-time})

(defn best-itinerary [home office]
  (def walk {:time (walking-time home office)})
  (def itineraries (map (fn [[line-name line]] 
    (calculate-itinerary line-name home office)) lines))
  (reduce #(if (< (get %1 :time) (get %2 :time)) %1 %2) walk itineraries))

(defn sort-listings [] 
  (->> listings 
    (map #(merge % (best-itinerary (get % :point) compass)))
    (sort-by :time)
    (run! println)))

(sort-listings)
