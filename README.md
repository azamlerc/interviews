# Interviews

Fun interview questions in various languages:

- C++
- Clojure
- Elixir
- Go
- Java
- JavaScript
- Kotlin
- Objective-C
- PHP
- Python
- Ruby
- Swift
- TypeScript

## Four Fours

Four fours is a mathematical puzzle. The goal is to find a mathematical expression for every whole number from 1 to 100, using only common mathematical symbols and the number four four times.

- Problem: https://en.wikipedia.org/wiki/Four_fours
- Playground: https://andrewzc.net/fourfours/

In this case, we will start with the initial values 4, .4, √4 and 4! and combine them using the operations addition, subtraction, multiplication and division.

Extension: Print out a solution for each number 1-100. If more than one solution is possible, print the shortest one.

## Subway Distance

Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as (blocks west of Ave A, blocks north of Houston). For example, the coordinates for the Compass office are (5,14) because it is at the intersection of 5 Av and 14 St. 

Extension: Allow transferring between two lines. 

- Visualization: https://andrewzc.net/subway.html

## Magic Names

Given a list of people, find the most popular first and last names. Which “magic” names can be both first and last names? Which “magic” people have magic first and last names?

Extension: Create a graph network of all names. Count how many clusters of people there are of each size.

- Diagram: https://andrewzc.net/interviews/names.pdf

## Pontifex

Pontifex implements the Solitaire encryption algorithm, as described in the appendix of the book Cryptonomicon by Neal Stephenson. Solitaire is a cypher that can be performed using a deck of playing cards. If two people each have a deck of playing cards in the same order, each can generate a keystream that can be used to encypher and decypher a message.

- Algorithm: https://www.schneier.com/academic/solitaire/
- Visualization: https://andrewzc.net/wikilinks/

## Wiki Links

What happens when you keep following the first link in Wikipedia articles? You almost always get back to the articles on Existence or Awareness. This program makes an outline of a selection of articles, and how they link back to the same loops. 

- Visualization: https://andrewzc.net/wikilinks/
