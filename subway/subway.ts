// Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

// Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as [blocks west of Ave A, blocks north of Houston]. For example, the coordinates for the Compass office are [5,14] because it is at the intersection of 5 Av and 14 St. 

const compass = [5,14];
const avenueBlock = 0.17; // miles
const streetBlock = 0.05; // miles
const walkingSpeed = 3.0; // miles per hour
const subwaySpeed = 17.0; // miles per hour
const entryTime = 3.0; // minutes to enter station and catch train
const dwellTime = 0.5; // minutes to wait in each intermediate station
const exitTime = 1.0; // minutes to exit station

// There are subway lines with stations at the following coordinates:
const lines = {
    "1": [[7,0], [7,4], [7,14], [7,18], [7,23], 
          [7,28], [7,34], [7,42], [7,50], [8,59]],
    "2": [[7,14], [7,34], [7,42]],
    "4": [[4,14], [3.75,42], [3.5,59]],
    "6": [[3.5,0], [4,8], [4,14], [4,23], [4,28], 
          [4,33], [3.75,42], [3.5,51], [3.5,59]],
    "A": [[6,4], [8,14], [8,34], [8,42], [8,59]],
    "C": [[6,4], [8,14], [8,23], [8,34], [8,42], 
          [8,50], [8,59]],
    "D": [[3.5,0], [6,4], [6,34], [6,42], [6,47], 
          [7,53], [8,59]],
    "F": [[2,0], [3.5,0], [6,4], [6,14], [6,23], 
          [6,34], [6,42], [6,47], [6,57]],
    "L": [[1,14], [3,14], [4,14], [6,14], [8,14]],
    "M": [[3.5,0], [6,4], [6,14], [6,23], [6,34], 
          [6,42], [6,47], [5,53], [3,53]],
    "Q": [[4,14], [6,34], [7,42], [7,57], [5,59]],
    "R": [[4,8], [4,14], [5,23], [5.5,28], [6,34], 
          [7,42], [7,49], [7,57], [5,59]],
};

// The task is to sort this array of listings by subway distance:
const listings = [
  {name: "Alphabet City", point: [0,3]},
  {name: "Hudson Yards", point: [11,34]},
  {name: "Times Square", point: [7,42]},
  {name: "Chelsea", point: [9,22]},
  {name: "Tompkins Square", point: [0,10]},
  {name: "East Village", point: [2,7.5]},
  {name: "Washington Square", point: [5,6]},
  {name: "Empire State", point: [5,34]},
  {name: "Grand Central", point: [3.75,42]},
  {name: "Kips Bay", point: [1, 33]},
  {name: "Hell's Kitchen", point: [9,55]},
];

listings.forEach((listing) => {  
  var itineraries = Object.keys(lines).map((lineName) => {
    return itineraryForLine(listing.point, lineName, compass);
  });
  itineraries.push({totalTime: walkingTime(listing.point, compass)});
  itineraries.sort((a,b) => a.totalTime - b.totalTime);
  var best = itineraries[0];
  listing.itinerary = best;
  listing.totalTime = best.totalTime;
});
listings.sort((a,b) => a.totalTime - b.totalTime);
listings.map((listing) => console.log(listing.name + ' - ' + printItinerary(listing.itinerary))); 

function printItinerary(itinerary) {
  if (!itinerary) {
    return '';
  } else if (itinerary.totalTime && !itinerary.lineName) {
    return `just walk - ${itinerary.totalTime} min` 
  } else {
    return `${itinerary.lineName} train from [${itinerary.startStation}] to [${itinerary.endStation}] - ${Math.round(itinerary.totalTime)} min`;
  }
}

function itineraryForLine(home, lineName, office) {
  var i = {lineName};
  var line = lines[lineName];
  var startIndex = indexOfNearestStation(line, home);
  var endIndex = indexOfNearestStation(line, office); // cache this
  i.startStation = line[startIndex];
  i.endStation = line[endIndex];
  var startWalkTime = walkingTime(home, i.startStation);
  var endWalkTime = walkingTime(i.endStation, office);
  var subwayTime = subwayJourneyTime(line, startIndex, endIndex);
  i.totalTime = startWalkTime + subwayTime + endWalkTime;
  return i;
}

// Returns the east/west distance in miles between two points.
function avenueDistance(pointA, pointB) {
  return Math.abs(pointA[0] - pointB[0]) * avenueBlock;
}
        
// Returns the north/south distance in miles between two points.
function streetDistance(pointA, pointB) {
  return Math.abs(pointA[1] - pointB[1]) * streetBlock;
}

// Minutes to walk between two points along the street grid.
function walkingTime(pointA, pointB) {
  var dx = avenueDistance(pointA, pointB);
  var dy = streetDistance(pointA, pointB);
  return (dx + dy) / walkingSpeed * 60.0;
}

// Minutes for a train to go between two adjacent stations on a line,
// which could go diagonally under the street grid.
function subwayTime(stationA, stationB) {
  var dx = avenueDistance(stationA, stationB);
  var dy = streetDistance(stationA, stationB);
  return Math.sqrt(dx * dx + dy * dy) / subwaySpeed * 60.0;
}

// Time to go down a subway line between stations at certain indexes.
function subwayJourneyTime(line, startIndex, endIndex) {
  var time = entryTime;
  
  if (startIndex > endIndex) {
    [startIndex, endIndex] = [endIndex, startIndex];
  }
  for (var a = startIndex; a < endIndex; a++) {
    var b = a + 1;
    time += subwayTime(line[a], line[b]);
    if (b != endIndex) time += dwellTime;
    
  }
  
  time += exitTime;
  return time;
}

// The index of a station on a line that is nearest to a given point.
function indexOfNearestStation(line, point) {
    var bestIndex = -1;
    var bestTime = -1;
  
    for (var i = 0; i < line.length; i++) {
      var time = walkingTime(line[i], point);
      if (bestIndex == -1 || time < bestTime) {
        bestIndex = i;
        bestTime = time;
      }
    }
  
    return bestIndex;
}
