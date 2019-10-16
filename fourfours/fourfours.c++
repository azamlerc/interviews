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

#include <iostream>
#include <set>
#include <string>
#include <vector>
#include <cmath>

using std::vector;
using std::set;

double roundValue(double value) {
  return std::round(value * 100000) / 100000;
}

void combineSets(vector<set<double>> & fours, int countA, int countB) {
  std::set<double> & destSet = fours[countA + countB];
  for (auto a : fours[countA]) {
    for (auto b : fours[countB]) {
      destSet.insert(a + b);
      destSet.insert(a - b);
      destSet.insert(b - a);
      destSet.insert(a * b);
      if (b != 0) {
        destSet.insert(roundValue(a / b));
      }
      if (a != 0) {
        destSet.insert(roundValue(b / a));
      }
    }
  }
}

vector<set<double>> fourFours() {
  vector<set<double>> fours(5);
  
  fours[1].insert(4);
  fours[1].insert(.4);
  fours[1].insert(sqrt(4));
  fours[1].insert(4*3*2*1);
  
  // your solution here
  // calcualte fours[2], fours[3] and fours[4]
  
  combineSets(fours, 1, 1);
  combineSets(fours, 1, 2);
  combineSets(fours, 1, 3);
  combineSets(fours, 2, 2);

  return fours;
}

template<typename T>
void printSet(std::string const & label, std::set<T> const & set) {
  std::cout << label << ": [ ";
  for (auto d : set) {
    std::cout << d << " ";
  }
  std::cout << "]\n\n";
}

void printFours(vector<set<double>> const & fours) {
  for (int i = 1; i < 4; i++) {
    printSet(std::to_string(i) + " fours", fours[i]);
  }

  auto const & four = fours[4];
  std::set<int> found, missing;
  for (int i = 1; i <= 100; i++) {
    if (four.find(i) != four.end()) {
      found.insert(i);
    } else {
      missing.insert(i); 
    }
  }
  
  printSet("4 fours", found);
  printSet("missing", missing);
  
  if (missing.size() == 6) {
    std::cout << "Success!";
  }
}

int main() {
  vector<set<double>> fours = fourFours();
  printFours(fours);
  
  return 0;
}
