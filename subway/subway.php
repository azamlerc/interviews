<?php

// Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

// Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as [blocks west of Ave A, blocks north of Houston]. For example, the coordinates for the Compass office are [5,14] because it is at the intersection of 5 Av and 14 St. 

// Visualization:
// https://andrewzc.net/subway.html

const compass = [5,14];
const avenueBlock = 0.17; // miles
const streetBlock = 0.05; // miles
const walkingSpeed = 3.0; // miles per hour
const subwaySpeed = 17.0; // miles per hour
const entryTime = 3.0; // minutes to enter station and catch train
const dwellTime = 0.5; // minutes to wait in each intermediate station
const exitTime = 1.0; // minutes to exit station

// There are subway lines with stations at the following coordinates:
$lines = [
  "1" => [[7,0], [7,4], [7,14], [7,18], [7,23], 
        [7,28], [7,34], [7,42], [7,50], [8,59]],
  "2" => [[7,14], [7,34], [7,42]],
  "4" => [[4,14], [3.75,42], [3.5,59]],
  "6" => [[3.5,0], [4,8], [4,14], [4,23], [4,28], 
        [4,33], [3.75,42], [3.5,51], [3.5,59]],
  "A" => [[6,4], [8,14], [8,34], [8,42], [8,59]],
  "C" => [[6,4], [8,14], [8,23], [8,34], [8,42], 
        [8,50], [8,59]],
  "D" => [[3.5,0], [6,4], [6,34], [6,42], [6,47], 
        [7,53], [8,59]],
  "F" => [[2,0], [3.5,0], [6,4], [6,14], [6,23], 
        [6,34], [6,42], [6,47], [6,57]],
  "L" => [[1,14], [3,14], [4,14], [6,14], [8,14]],
  "M" => [[3.5,0], [6,4], [6,14], [6,23], [6,34], 
        [6,42], [6,47], [5,53], [3,53]],
  "Q" => [[4,14], [6,34], [7,42], [7,57], [5,59]],
  "R" => [[4,8], [4,14], [5,23], [5.5,28], [6,34], 
        [7,42], [7,49], [7,57], [5,59]],
];

// The task is to sort this array of listings by subway distance:
$listings = [
  ["name" => "Alphabet City", "point" => [0,3]],
  ["name" => "Hudson Yards", "point" => [11,34]],
  ["name" => "Times Square", "point" => [7,42]],
  ["name" => "Chelsea", "point" => [9,22]],
  ["name" => "Tompkins Square", "point" => [0,10]],
  ["name" => "East Village", "point" => [2,7.5]],
  ["name" => "Washington Square", "point" => [5,6]],
  ["name" => "Empire State", "point" => [5,34]],
  ["name" => "Grand Central", "point" => [3.75,42]],
  ["name" => "Kips Bay", "point" => [1, 33]],
  ["name" => "Hell's Kitchen", "point" => [9,55]],
];

// Returns the east/west distance in miles between two points.
function avenueDistance($pointA, $pointB) {
  return abs($pointA[0] - $pointB[0]) * avenueBlock;
}
        
// Returns the north/south distance in miles between two points.
function streetDistance($pointA, $pointB) {
  return abs($pointA[1] - $pointB[1]) * streetBlock;
}

// Minutes to walk between two points along the street grid.
function walkingTime($pointA, $pointB) {
  $dx = avenueDistance($pointA, $pointB);
  $dy = streetDistance($pointA, $pointB);
  return ($dx + $dy) / walkingSpeed * 60.0;
}

// Minutes for a train to go between two adjacent stations on a line,
// which could go diagonally under the street grid.
function subwayTime($stationA, $stationB) {
  $dx = avenueDistance($stationA, $stationB);
  $dy = streetDistance($stationA, $stationB);
  return sqrt($dx * $dx + $dy * $dy) / subwaySpeed * 60.0;
}

// Time to go down a subway line between stations at certain indexes.
function subwayJourneyTime($line, $startIndex, $endIndex) {
  $time = entryTime;
  
  // if going downtown, swap the stations
  if ($startIndex > $endIndex) {
    $temp = $startIndex;
    $startIndex = $endIndex;
    $endIndex = $temp;
  }
  for ($a = $startIndex; $a < $endIndex; $a++) {
    $b = $a + 1;
    $time += subwayTime($line[$a], $line[$b]);
    // don't need to wait for the train to leave the end station
    if ($b != $endIndex) $time += dwellTime;
  }
  
  $time += exitTime;
  return $time;
}

// The index of a station on a line that is nearest to a given point.
function indexOfNearestStation($line, $point) {
    $bestIndex = -1;
    $bestTime = -1;
  
    for ($i = 0; $i < count($line); $i++) {
      $time = walkingTime($line[$i], $point);
      if ($bestIndex == -1 || $time < $bestTime) {
        $bestIndex = $i;
        $bestTime = $time;
      }
    }
  
    return $bestIndex;
}

function itineraryForLine($lineName, $home, $office) {
  global $lines;
  $itinerary = ["lineName" => $lineName];
  $line = $lines[$lineName];
  $startIndex = indexOfNearestStation($line, $home);
  $endIndex = indexOfNearestStation($line, $office);
  $itinerary["startStation"] = $line[$startIndex];
  $itinerary["endStation"] = $line[$endIndex];
  $startWalkTime = walkingTime($home, $itinerary["startStation"]);
  $endWalkTime = walkingTime($itinerary["endStation"], $office);
  $subwayTime = subwayJourneyTime($line, $startIndex, $endIndex);
  $itinerary["totalTime"] = $startWalkTime + $subwayTime + $endWalkTime;
  return $itinerary;
}

function compareItinerary($a, $b) {
  return $a["totalTime"] <=> $b["totalTime"];
}

function compareListing($a, $b) {
  return $a["itinerary"]["totalTime"] <=> $b["itinerary"]["totalTime"];
}

function printPoint($point) {
  return "[" . $point[0] . "," . $point[1] . "]";
}

function printItinerary($itinerary) {
  if (!$itinerary) {
    return "";
  } else if (array_key_exists("totalTime", $itinerary) && !array_key_exists("lineName", $itinerary)) {
    return "just walk - " . $itinerary["totalTime"] . " min"; 
  } else {
    return $itinerary["lineName"] . " train from " .  printPoint($itinerary["startStation"]) . " to " . printPoint($itinerary["endStation"]) . " - " .   $itinerary["totalTime"] . " min";
  }
}

foreach ($listings as &$listing) {
  $itineraries = array();
  foreach ($lines as $lineName => $line) {
    $itinerary = itineraryForLine($lineName, $listing["point"], compass);
    array_push($itineraries, $itinerary);    
  }
  $justWalk = ["totalTime" => walkingTime($listing["point"], compass)];
  array_push($itineraries, $justWalk);
  usort($itineraries, "compareItinerary");
  $listing["itinerary"] = $itineraries[0];
}
usort($listings, "compareListing");
foreach ($listings as $listing) {
  echo($listing["name"] . " - " . printItinerary($listing["itinerary"]) . "\n");
}

?>
