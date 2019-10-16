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

import Foundation

// A dictionary of sets that stores which nubmers can be generated
// with one, two, three, or four of the number four.
var fours = [Int:Set<Double>]()

func computeFours() {
  fours[1] = Set([0.4, 2, 4, 24]) // .4, √4, 4, 4!
  fours[2] = Set()
  fours[3] = Set()
  fours[4] = Set()
  
  combine(countA: 1, countB: 1)
  combine(countA: 1, countB: 2)
  combine(countA: 1, countB: 3)
  combine(countA: 2, countB: 2)
}

func combine(countA: Int, countB: Int) {
  var newSet = fours[countA + countB]!
  for valueA in fours[countA]! {
    for valueB in fours[countB]! {
      newSet.insert(rounded(valueA + valueB))
      newSet.insert(rounded(valueA - valueB))
      newSet.insert(rounded(valueB - valueA))
      newSet.insert(rounded(valueA * valueB))
      if valueB != 0 {
        newSet.insert(rounded(valueA / valueB))
      }
      if valueA != 0 {
        newSet.insert(rounded(valueB / valueA))
      }
    }
  }
  fours[countA + countB]! = newSet
}

func rounded(_ value: Double) -> Double {
  return (value * 1000000).rounded() / 1000000
}

func printFours() {
  for var count in 1..<4 {
    print(count, "fours: ", Array(fours[count]!).sorted(), "\n")  
  }
  let fourSet = fours[4]!
  var found = [Int]()
  var missing = [Int]()
  for var i in 1..<101 {
    if fourSet.contains(Double(i)) {
      found.append(i)
    } else {
      missing.append(i)
    }
  }
  print("4 fours: ", found, "\n")
  print("missing: ", missing, "\n")
  if missing == [73, 77, 81, 87, 93, 99] {
    print("Success!") 
  }
}

computeFours()
printFours()
