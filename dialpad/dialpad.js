let englishWords = ["A", "ACE", "BAD", "DEAL", "DECK", "ANDREW", "DAN", "VICTORIA"]
let wordSet = new Set(englishWords);

let pad = {
  "1": [""],
  "2": ["A", "B", "C"],
  "3": ["D", "E", "F"],
  "4": ["G", "H", "I"],
  "5": ["J", "K", "L"],
  "6": ["M", "N", "O"],
  "7": ["P", "Q", "R", "S"],
  "8": ["T", "U", "V"],
  "9": ["W", "X", "Y", "Z"],
  "0": [""]
};

function pathways(matrix) {
  if (matrix.length == 0) return [""];

  let words = [""];
  let head = matrix[0];
  let tail = matrix.slice(1);
  
  head.forEach((letter) =>
    pathways(tail).forEach((child) => 
      words.push(letter + child)));
  
  return words;
}

function findWords(numberString) {
  let numbers = numberString.split('');
  let length = numberString.length;
  let matrix = numbers.map((number) => pad[number]);
  return pathways(matrix)
    .filter((word) => word.length == length)
    .filter((word) => wordSet.has(word));
}

console.log(findWords("223"));
console.log(findWords("3325"));
console.log(findWords("263739"));
console.log(findWords("326"));
console.log(findWords("84286742"));
