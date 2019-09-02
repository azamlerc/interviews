<?php

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

function combine(&$fours, $countA, $countB) {
  $newSet = &$fours[$countA + $countB];
  foreach ($fours[$countA] as $keyA => $boolA) {
    $valueA = floatval($keyA);
    foreach ($fours[$countB] as $keyB => $boolB) {
      $valueB = floatval($keyB);  
      
      $newSet[strval($valueA + $valueB)] = true;
      $newSet[strval($valueA - $valueB)] = true;
      $newSet[strval($valueB - $valueA)] = true;
      $newSet[strval($valueA * $valueB)] = true;
      if ($valueB != 0) {
        $newSet[strval($valueA / $valueB)] = true;
      }
      if ($valueA != 0) {
        $newSet[strval($valueB / $valueA)] = true;
      }
    }
  }
}

function fourFours() {
  $fours = array(array(), array(), array(), array(), array());
  $fours[1]["4"] = true;
  $fours[1]["0.4"] = true;
  $fours[1]["2"] = true;
  $fours[1]["24"] = true;
  
  // your solution here
  // calcualte fours[2], fours[3] and fours[4]

  combine($fours, 1, 1);
  combine($fours, 1, 2);
  combine($fours, 1, 3);
  combine($fours, 2, 2);

  return $fours;
}

function printFours($fours) {
  for ($i = 1; $i <= 3; $i++) {
    $values = array_keys($fours[$i]);
    sort($values);
    echo($i . " fours: [" . join(", ", $values) . "]\n\n");
  }
  $found = array();
  $missing = array();
  for ($i = 1; $i <= 100; $i++) {
    if (array_key_exists($i, $fours[4])) {
      array_push($found, $i);
    } else {
      array_push($missing, $i);
    }
  }
  echo("4 fours: [" . join(", ", $found) . "]\n\n"); 
  echo("missing: [" . join(", ", $missing) . "]\n\n"); 
  if (count($missing) == 6) {
    echo('Success!'); 
  }
}

$fours = fourFours();
printFours($fours);

?>
