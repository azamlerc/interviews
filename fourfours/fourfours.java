// Four fours is a mathematical puzzle. The goal is to find a mathematical
// expression for every whole number from 1 to 100, using only common
// mathematical symbols and the number four four times.
//
// See https://en.wikipedia.org/wiki/Four_fours
//
// In this case, we will start with the initial values 4, .4, √4 and 4!
// and combine them using the operations addition, subtraction,
// multiplication and division.

import java.io.*;
import java.util.*;
import java.lang.Math.*;

class Solution {
  // Returns a list of sets of numbers that can be generated with 
  // zero, one, two, three, or four of the number four.
  public static List<Set<Double>> fourFours() {
    List<Set<Double>> fours = new ArrayList<Set<Double>>();
    for (int i = 0; i <= 4; i++) {
      fours.add(new HashSet<Double>());
    }    
    
    fours.get(1).add(4.0);
    fours.get(1).add(0.4);
    fours.get(1).add(Math.sqrt(4));
    fours.get(1).add(24.0); // 4!
 
    combine(fours, 1, 1);
    combine(fours, 1, 2);
    combine(fours, 1, 3);
    combine(fours, 2, 2);
    
    return fours;
  }

  public static void combine(List<Set<Double>>fours, int countA, int countB) {
    Set<Double> newSet = fours.get(countA + countB);
    for (Double valueA : fours.get(countA)) {
      for (Double valueB : fours.get(countB)) {
        newSet.add(round(valueA + valueB));
        newSet.add(round(valueA - valueB));
        newSet.add(round(valueB - valueA));
        newSet.add(round(valueA * valueB));
        if (valueB != 0) {
          newSet.add(round(valueA / valueB));  
        }
        if (valueA != 0) {
          newSet.add(round(valueB / valueA));  
        }
      }
    }
  }
  
  public static Double round(Double value) {
    return Math.round(value * 100000d) / 100000d;
  }
  
  public static void printFours(List<Set<Double>> fours) {
    for (int count = 1; count <= 3; count++) {
      ArrayList<Double> array = new ArrayList<Double>(fours.get(count));
      Collections.sort(array);
      System.out.println(count + " fours: " + array + "\n");       
    }
    Set<Double> set = fours.get(4);
    ArrayList<Integer> found = new ArrayList<Integer>();
    ArrayList<Integer> missing = new ArrayList<Integer>();
    for (int i = 1; i <= 100; i++) {
      if (set.contains((double)i)) {
        found.add(i);
      } else {
        missing.add(i);
      }
    }
    System.out.println("4 fours: " + found + "\n");
    System.out.println("Missing: " + missing + "\n");
    
    if (missing.toString().equals("[73, 77, 81, 87, 93, 99]")) {
      System.out.println("Success!");
    }
  }
  
  public static void main(String[] args) {
    List<Set<Double>> fours = fourFours();
    printFours(fours);
  }
}