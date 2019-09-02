// Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

// Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as [blocks west of Ave A, blocks north of Houston]. For example, the coordinates for the Compass office are [5,14] because it is at the intersection of 5 Av and 14 St. 

// Visualization:
// http://www.zamler-carhart.com/andrew/subway.html

package main

import (
  "fmt"
  "math"
  "sort"
)

type point struct {
  Avenue float64
  Street float64
}

type line []point

type itinerary struct {
  LineName *string
  StartStation *point
  EndStation *point
  TotalTime float64 
}

type listing struct {
  Name string
  Address point
  Itinerary *itinerary
  TotalTime *float64
}

var compass = point{5,14}

const (
  avenueBlock = 0.17 // miles
  streetBlock = 0.05 // miles
  walkingSpeed = 3.0 // miles per hour
  subwaySpeed = 17.0 // miles per hour
  entryTime = 3.0 // minutes to enter station and catch train
  dwellTime = 0.5 // minutes to wait in each intermediate station
  exitTime = 1.0 // minutes to exit station
)

// There are subway lines with stations at the following coordinates:
var lines = map[string]line{
    "1": line{point{7,0}, point{7,4}, point{7,14}, 
              point{7,18}, point{7,23}, point{7,28}, 
              point{7,34}, point{7,42}, point{7,50}, 
              point{8,59}},
    "2": line{point{7,14}, point{7,34}, point{7,42}},
    "4": line{point{4,14}, point{3.75,42}, point{3.5,59}},
    "6": line{point{3.5,0}, point{4,8}, point{4,14}, 
              point{4,23}, point{4,28}, point{4,33}, 
              point{3.75,42}, point{3.5,51}, point{3.5,59}},
    "A": line{point{6,4}, point{8,14}, point{8,34}, 
              point{8,42}, point{8,59}},
    "C": line{point{6,4}, point{8,14}, point{8,23}, 
              point{8,34}, point{8,42}, point{8,50}, 
              point{8,59}},
    "D": line{point{3.5,0}, point{6,4}, point{6,34}, 
              point{6,42}, point{6,47}, point{7,53}, 
              point{8,59}},
    "F": line{point{2,0}, point{3.5,0}, point{6,4}, 
              point{6,14}, point{6,23}, point{6,34}, 
              point{6,42}, point{6,47}, point{6,57}},
    "L": line{point{1,14}, point{3,14}, point{4,14}, 
              point{6,14}, point{8,14}},
    "M": line{point{3.5,0}, point{6,4}, point{6,14}, 
              point{6,23}, point{6,34}, point{6,42}, 
              point{6,47}, point{5,53}, point{3,53}},
    "Q": line{point{4,14}, point{6,34}, point{7,42}, 
              point{7,57}, point{5,59}},
    "R": line{point{4,8}, point{4,14}, point{5,23}, 
              point{5.5,28}, point{6,34}, point{7,42}, 
              point{7,49}, point{7,57}, point{5,59}},
}

// The task is to sort this array of listings by subway distance:
var listings = []listing{
  listing{Name: "Alphabet City", Address: point{0,3}},
  listing{Name: "Hudson Yards", Address: point{11,34}},
  listing{Name: "Times Square", Address: point{7,42}},
  listing{Name: "Chelsea", Address: point{9,22}},
  listing{Name: "Tompkins Square", Address: point{0,10}},
  listing{Name: "East Village", Address: point{2,7.5}},
  listing{Name: "Washington Square", Address: point{5,6}},
  listing{Name: "Empire State", Address: point{5,34}},
  listing{Name: "Grand Central", Address: point{3.75,42}},
  listing{Name: "Kips Bay", Address: point{1, 33}},
  listing{Name: "Hell's Kitchen", Address: point{9,55}},
}

// Returns the east/west distance in miles between two points.
func avenueDistance(pointA, pointB point) float64 {
  return math.Abs(pointA.Avenue - pointB.Avenue) * avenueBlock
}
        
// Returns the north/south distance in miles between two points.
func streetDistance(pointA, pointB point) float64 {
  return math.Abs(pointA.Street - pointB.Street) * streetBlock
}

// Minutes to walk between two points along the street grid.
func walkingTime(pointA, pointB point) float64 {
  dx := avenueDistance(pointA, pointB)
  dy := streetDistance(pointA, pointB)
  return (dx + dy) / walkingSpeed * 60.0
}

// Minutes for a train to go between two adjacent stations on a line,
// which could go diagonally under the street grid.
func subwayTime(stationA, stationB point) float64 {
  dx := avenueDistance(stationA, stationB)
  dy := streetDistance(stationA, stationB)
  return math.Sqrt(dx * dx + dy * dy) / subwaySpeed * 60.0
}

// Time to go down a subway line between stations at certain indexes.
func subwayJourneyTime(line line, startIndex int, endIndex int) float64 {
  time := entryTime
  
  // if going downtown, swap the stations
  if startIndex > endIndex {
    startIndex, endIndex = endIndex, startIndex
  }
  for a := startIndex; a < endIndex; a++ {
    b := a + 1
    time += subwayTime(line[a], line[b])
    // don't need to wait for the train to leave the end station
    if b != endIndex {
      time += dwellTime
    }
  }
  
  time += exitTime
  return time
}

// The index of a station on a line that is nearest to a given point.
func indexOfNearestStation(line line, point point) int {
  bestIndex := -1
  bestTime := 0.0
  
  for i := 0; i < len(line); i++ {
    time := walkingTime(line[i], point)
    if bestIndex == -1 || time < bestTime {
      bestIndex = i
      bestTime = time
    }
  }
  
  return bestIndex
}

func printPoint(point point) string {
  return fmt.Sprintf("(%.0f,%.0f)", point.Avenue, point.Street)
}

func printItinerary(itinerary *itinerary) string {
  if itinerary == nil {
    return ""
  } else if itinerary.LineName == nil {
    return fmt.Sprintf("just walk - %.0f min", itinerary.TotalTime)
  } else {
    return fmt.Sprintf("%s train from %s to %s - %.0f min", *itinerary.LineName, printPoint(*itinerary.StartStation), printPoint(*itinerary.EndStation), itinerary.TotalTime)
  }
}

func itineraryForLine(home point, lineName string, office point) itinerary {
  i := itinerary{LineName: &lineName}
  line := lines[lineName]
  startIndex := indexOfNearestStation(line, home)
  endIndex := indexOfNearestStation(line, office)
  i.StartStation = &line[startIndex]
  i.EndStation = &line[endIndex]
  startWalkTime := walkingTime(home, *i.StartStation)
  endWalkTime := walkingTime(*i.EndStation, office)
  subwayTime := subwayJourneyTime(line, startIndex, endIndex)
  i.TotalTime = startWalkTime + subwayTime + endWalkTime
  return i
}

func main() {
  var newListings []listing
  for _, listing := range listings {
    var itineraries []itinerary
    for lineName := range lines {
      itinerary := itineraryForLine(listing.Address, lineName, compass)
      itineraries = append(itineraries, itinerary)
    }
    
    walking := itinerary{TotalTime: walkingTime(listing.Address, compass)}
    itineraries = append(itineraries, walking)
    
    sort.Slice(itineraries, func(i, j int) bool {
      return itineraries[i].TotalTime < itineraries[j].TotalTime
    })

    best := itineraries[0]
    listing.Itinerary = &best
    listing.TotalTime = &best.TotalTime
    newListings = append(newListings, listing)
  }
  sort.Slice(newListings, func(i, j int) bool {
    return *newListings[i].TotalTime < *newListings[j].TotalTime
  })

  for _, listing := range newListings {
    fmt.Printf("%s - %s\n", listing.Name, printItinerary(listing.Itinerary)) 
  }
}