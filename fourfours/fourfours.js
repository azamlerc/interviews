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

// Returns a list of sets of numbers that can be generated with 
// zero, one, two, three, or four of the number four.
function fourFours() {
  const fours = [
    new Set(), 
    new Set([4, .4, Math.sqrt(4), 4*3*2*1]), // √4, 4!
    new Set(), 
    new Set(), 
    new Set()];
  
  combine(fours, 1, 1);
  combine(fours, 1, 2);
  combine(fours, 1, 3);
  combine(fours, 2, 2);
  
  return fours;
}

function combine(fours, countA, countB) {
  const newSet = fours[countA + countB];
  for (let valueA of fours[countA]) {
    for (let valueB of fours[countB]) {
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

function round(value) {
  return +(Math.round(value + "e+6") + "e-6");
}

function printFours(fours) {
  for (let count = 1; count <= 3; count++) {
    const array = Array.from(fours[count]).sort((a,b) => a - b);
    console.log(`${count} fours: ${JSON.stringify(array)}\n`); 
  }
  let found = [];
  let missing = [];
  for (let i = 1; i <= 100; i++) {
    if (fours[4].has(i)) {
      found.push(i);
    } else {
      missing.push(i);
    }
  }
  console.log(`4 fours: ${JSON.stringify(found)}\n`); 
  console.log(`missing: ${JSON.stringify(missing)}\n`); 
  if (JSON.stringify(missing) === '[73,77,81,87,93,99]') {
    console.log('Success!'); 
  }
}

const fours = fourFours();
printFours(fours);
