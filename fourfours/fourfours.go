// Four fours is a mathematical puzzle. The goal is to find a mathematical
// expression for every whole number from 1 to 100, using only common
// mathematical symbols and the number four four times.
//
// Problem: https://en.wikipedia.org/wiki/Four_fours
// Playground: https://andrewzc.net/fourfours/
//
// In this case, we will start with the initial values 4, .4, √4 and 4!
// and combine them using the operations addition, subtraction,
// multiplication and division.

package main

import (
  "fmt"
  "math"
  "reflect"
  "sort"
)

// Returns a slice of maps, each of which stores which numbers can be
// generated using zero, one, two, three, or four fours. 
// The keys in each map are the numbers, and the values are boolean true.
func fourFours() []map[float64]bool {
  var fours = []map[float64]bool{{}, {}, {}, {}, {}}
  fours[1][4] = true
  fours[1][.4] = true  
  fours[1][math.Sqrt(4)] = true // √4 
  fours[1][4*3*2*1] = true // 4!
  
  combine(fours, 1, 1)
  combine(fours, 1, 2)
  combine(fours, 1, 3)
  combine(fours, 2, 2)
  
  return fours
}

func combine(fours []map[float64]bool, countA int, countB int) {
  var newMap = fours[countA + countB]
  for valueA := range fours[countA] {
    for valueB := range fours[countB] {
      newMap[round(valueA + valueB)] = true
      newMap[round(valueA - valueB)] = true
      newMap[round(valueB - valueA)] = true
      newMap[round(valueA * valueB)] = true
      if valueB != 0 {
        newMap[round(valueA / valueB)] = true
      }
      if valueA != 0 {
        newMap[round(valueB / valueA)] = true
      }
    }
  }
}

func round(value float64) float64 {
  return float64(int64(value / .000001 + 0.5)) * .000001
}

func printFours(fours []map[float64]bool) {
  for count := 1; count < 4; count++ {
    fmt.Printf("%d fours: %+v\n\n", count, mapKeys(fours[count]))
  }
  var found []int
  var missing []int 
  for i := 1; i <= 100; i++ {
    if fours[4][float64(i)] {
      found = append(found, i)
    } else {
      missing = append(missing, i)
    }
  }
  fmt.Printf("4 fours: %+v\n\n", found)
  fmt.Printf("missing: %+v\n\n", missing)
  if reflect.DeepEqual(missing, []int{73, 77, 81, 87, 93, 99}) {
    fmt.Println("Success!")
  }
}

func mapKeys(numberMap map[float64]bool) []float64 {
  keys := make([]float64, len(numberMap))
  i := 0
  for k := range numberMap {
      keys[i] = k
      i++
  }
  sort.Float64s(keys)
  return keys
}

func main() {
  fours := fourFours()
  printFours(fours)
}
