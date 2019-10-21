# -*- coding: UTF-8 -*-
# Four fours is a mathematical puzzle. The goal is to find a mathematical
# expression for every whole number from 1 to 100, using only common
# mathematical symbols and the number four four times.
#
# Problem: https://en.wikipedia.org/wiki/Four_fours
# Playground: https://andrewzc.net/fourfours/
#
# In this case, we will start with the initial values 4, .4, √4 and 4!
# and combine them using the operations addition, subtraction,
# multiplication and division.

import math

# Returns a dictionary of sets of numbers that can be generated
# with one, two, three, or four of the number four.
def fourFours():
    fours = {1: set(), 2: set(), 3: set(), 4: set()}
    fours[1].update([.4, 4, math.sqrt(4), math.factorial(4)])

    combine(fours, 1, 1)
    combine(fours, 1, 2)
    combine(fours, 1, 3)
    combine(fours, 2, 2)
    
    return fours

def combine(fours, countA, countB):
    newSet = fours[countA + countB]
    for valueA in fours[countA]:
        for valueB in fours[countB]:
            newSet.add(round(valueA + valueB, 6))
            newSet.add(round(valueA - valueB, 6))
            newSet.add(round(valueB - valueA, 6))
            newSet.add(round(valueA * valueB, 6))
            if valueB != 0:
                newSet.add(round(valueA / valueB, 6))
            if valueA != 0:
                newSet.add(round(valueB / valueA, 6))

def printFours(fours):
    for count in range(1, 4):
        resultSet = fours[count]    
        resultArray = sorted(list(resultSet))
        print(count, "fours:", resultArray, "\n")
    found = []
    missing = []
    for i in range (1, 101):
        if i in fours[4]:
            found.append(i)
        else:
            missing.append(i)
    print("4 fours:", found, "\n")
    print("missing:", missing, "\n")
    if missing == [73, 77, 81, 87, 93, 99]:
        print("Success!")
    
    
fours = fourFours()
printFours(fours)
