// Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

// Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as (blocks west of Ave A, blocks north of Houston). For example, the coordinates for the Compass office are (5,14) because it is at the intersection of 5 Av and 14 St. 

// Visualization:
// https://andrewzc.net/subway.html

import Foundation

typealias Point = (Double,Double)
typealias Line = [Point]

let compass: Point = (5,14)
let avenueBlock = 0.17 // miles
let streetBlock = 0.05 // miles
let walkingSpeed = 3.0 // miles per hour
let subwaySpeed = 17.0 // miles per hour
let entryTime = 3.0 // minutes to enter station and catch train
let dwellTime = 0.5 // minutes to wait in each intermediate station
let exitTime = 1.0 // minutes to exit station

// There are subway lines with stations at the following coordinates:
let lines: [String:Line] = [
    "1": [(7,0), (7,4), (7,14), (7,18), (7,23), 
          (7,28), (7,34), (7,42), (7,50), (8,59)],
    "2": [(7,14), (7,34), (7,42)],
    "4": [(4,14), (3.75,42), (3.5,59)],
    "6": [(3.5,0), (4,8), (4,14), (4,23), (4,28), 
          (4,33), (3.75,42), (3.5,51), (3.5,59)],
    "A": [(6,4), (8,14), (8,34), (8,42), (8,59)],
    "C": [(6,4), (8,14), (8,23), (8,34), (8,42), 
          (8,50), (8,59)],
    "D": [(3.5,0), (6,4), (6,34), (6,42), (6,47), 
          (7,53), (8,59)],
    "F": [(2,0), (3.5,0), (6,4), (6,14), (6,23), 
          (6,34), (6,42), (6,47), (6,57)],
    "L": [(1,14), (3,14), (4,14), (6,14), (8,14)],
    "M": [(3.5,0), (6,4), (6,14), (6,23), (6,34), 
          (6,42), (6,47), (5,53), (3,53)],
    "Q": [(4,14), (6,34), (7,42), (7,57), (5,59)],
    "R": [(4,8), (4,14), (5,23), (5.5,28), (6,34), 
          (7,42), (7,49), (7,57), (5,59)]
]

struct Property {
  var name: String
  var point: Point
}

// The task is to sort this array of listings by subway distance:
let properties = [
  Property(name: "Alphabet City", point: (0,3)),
  Property(name: "Hudson Yards", point: (11,34)),
  Property(name: "Times Square", point: (7,42)),
  Property(name: "Chelsea", point: (9,22)),
  Property(name: "Tompkins Square", point: (0,10)),
  Property(name: "East Village", point: (2,7.5)),
  Property(name: "Washington Square", point: (5,6)),
  Property(name: "Empire State", point: (5,34)),
  Property(name: "Grand Central", point: (3.75,42)),
  Property(name: "Kips Bay", point: (1, 33)),
  Property(name: "Hell's Kitchen", point: (9,55)),
]

// Returns the east/west distance in miles between two points.
func avenueDistance(_ pointA: Point, _ pointB: Point) -> Double {
  return abs(pointA.0 - pointB.0) * avenueBlock
}
        
// Returns the north/south distance in miles between two points.
func streetDistance(_ pointA: Point, _ pointB: Point) -> Double {
  return abs(pointA.1 - pointB.1) * streetBlock
}

// Minutes to walk between two points along the street grid.
func walkingTime(_ pointA: Point, _ pointB: Point) -> Double {
  let dx = avenueDistance(pointA, pointB)
  let dy = streetDistance(pointA, pointB)
  return (dx + dy) / walkingSpeed * 60.0
}

// Minutes for a train to go between two adjacent stations on a line,
// which could go diagonally under the street grid.
func subwayTime(_ stationA: Point, _ stationB: Point) -> Double {
  let dx = avenueDistance(stationA, stationB)
  let dy = streetDistance(stationA, stationB)
  return (dx * dx + dy * dy).squareRoot() / subwaySpeed * 60.0
}

// Time to go down a subway line between stations at certain indexes.
func subwayJourneyTime(line: Line, start: Int, end: Int) -> Double {
  var startIndex = start
  var endIndex = end
  var time = entryTime
  
  if (startIndex > endIndex) {
    (startIndex, endIndex) = (endIndex, startIndex)
  }
  for a in startIndex..<endIndex {
    let b = a + 1
    time += subwayTime(line[a], line[b])
    if b != endIndex {
      time += dwellTime
    }    
  }
  
  time += exitTime
  return time
}

// The index of a station on a line that is nearest to a given point.
func indexOfNearestStation(line: [Point], point: Point) -> Int {
    var bestIndex = -1
    var bestTime = -1.0
  
    for (i, station) in line.enumerated() {
      let time = walkingTime(station, point)
      if bestIndex == -1 || time < bestTime {
        bestIndex = i
        bestTime = time
      }
    }
  
    return bestIndex
}

struct Listing {
  var property: Property
  var itinerary: Itinerary
}

struct Itinerary {
  var lineName: String?
  var startStation: Point?
  var endStation: Point?
  var totalTime: Double
}

func itineraryForLine(home: Point, 
                      lineName: String, 
                      office: Point) -> Itinerary {
  let line = lines[lineName]!
  let startIndex = indexOfNearestStation(line: line, point: home)
  let endIndex = indexOfNearestStation(line: line, point: office)
  let startStation = line[startIndex]
  let endStation = line[endIndex]
  let startWalkTime = walkingTime(home, startStation)
  let endWalkTime = walkingTime(endStation, office)
  let subwayTime = subwayJourneyTime(line: line, 
                                     start: startIndex, 
                                     end: endIndex)
  let totalTime = startWalkTime + subwayTime + endWalkTime
  return Itinerary(lineName: lineName, 
                    startStation: startStation, 
                    endStation: endStation, 
                    totalTime: totalTime)
}

func printItinerary(_ itinerary: Itinerary?) -> String {
  guard let i = itinerary else {
    return ""
  }
  if i.lineName == nil {
    return "just walk - \(i.totalTime) min"
  } else {
    return "\(i.lineName!) train from \(i.startStation!) to \(i.endStation!) - \(Int(i.totalTime)) min";
  }
}

var listings = [Listing]()
for property in properties {
  var itineraries = [Itinerary]()
  for (lineName, _) in lines {
    itineraries.append(itineraryForLine(home: property.point, 
                                        lineName: lineName, 
                                        office: compass))
  }
  let justWalk = walkingTime(property.point, compass)
  itineraries.append(Itinerary(lineName: nil, 
                               startStation: nil, 
                               endStation: nil, 
                               totalTime: justWalk))
  itineraries.sort { (a, b) in return a.totalTime < b.totalTime }
  let best = itineraries[0]
  listings.append(Listing(property: property, 
                          itinerary: best))
}
listings.sort { (a, b) in return a.itinerary.totalTime < b.itinerary.totalTime }
for listing in listings {
  print(listing.property.name + " - " + printItinerary(listing.itinerary))
}