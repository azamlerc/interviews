// Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

// Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as (blocks west of Ave A, blocks north of Houston). For example, the coordinates for the Compass office are (5,14) because it is at the intersection of 5 Av and 14 St. 

// Visualization:
// https://andrewzc.net/subway.html

import kotlin.math.*

typealias Point = Pair<Double,Double>
typealias Line = List<Point>

val compass = Point(5.0,14.0)
const val avenueBlock = 0.17 // miles
const val streetBlock = 0.05 // miles
const val walkingSpeed = 3.0 // miles per hour
const val subwaySpeed = 17.0 // miles per hour
const val entryTime = 3.0 // minutes to enter station and catch train
const val dwellTime = 0.5 // minutes to wait in each intermediate station
const val exitTime = 1.0 // minutes to exit station

// There are subway lines with stations at the following coordinates:
val lines: HashMap<String,Line> = hashMapOf(
    "1" to listOf(Point(7.0,0.0), Point(7.0,4.0), Point(7.0,14.0), Point(7.0,18.0), Point(7.0,23.0), Point(7.0,28.0), Point(7.0,34.0), Point(7.0,42.0), Point(7.0,50.0), Point(8.0,59.0)),
    "2" to listOf(Point(7.0,14.0), Point(7.0,34.0), Point(7.0,42.0)),
    "4" to listOf(Point(4.0,14.0), Point(3.75,42.0), Point(3.5,59.0)),
    "6" to listOf(Point(3.5,0.0), Point(4.0,8.0), Point(4.0,14.0), Point(4.0,23.0), Point(4.0,28.0), Point(4.0,33.0), Point(3.75,42.0), Point(3.5,51.0), Point(3.5,59.0)),
    "A" to listOf(Point(6.0,4.0), Point(8.0,14.0), Point(8.0,34.0), Point(8.0,42.0), Point(8.0,59.0)),
    "C" to listOf(Point(6.0,4.0), Point(8.0,14.0), Point(8.0,23.0), Point(8.0,34.0), Point(8.0,42.0), Point(8.0,50.0), Point(8.0,59.0)),
    "D" to listOf(Point(3.5,0.0), Point(6.0,4.0), Point(6.0,34.0), Point(6.0,42.0), Point(6.0,47.0), Point(7.0,53.0), Point(8.0,59.0)),
    "F" to listOf(Point(2.0,0.0), Point(3.5,0.0), Point(6.0,4.0), Point(6.0,14.0), Point(6.0,23.0), Point(6.0,34.0), Point(6.0,42.0), Point(6.0,47.0), Point(6.0,57.0)),
    "L" to listOf(Point(1.0,14.0), Point(3.0,14.0), Point(4.0,14.0), Point(6.0,14.0), Point(8.0,14.0)),
    "M" to listOf(Point(3.5,0.0), Point(6.0,4.0), Point(6.0,14.0), Point(6.0,23.0), Point(6.0,34.0), Point(6.0,42.0), Point(6.0,47.0), Point(5.0,53.0), Point(3.0,53.0)),
    "Q" to listOf(Point(4.0,14.0), Point(6.0,34.0), Point(7.0,42.0), Point(7.0,57.0), Point(5.0,59.0)),
    "R" to listOf(Point(4.0,8.0), Point(4.0,14.0), Point(5.0,23.0), Point(5.5,28.0), Point(6.0,34.0), Point(7.0,42.0), Point(7.0,49.0), Point(7.0,57.0), Point(5.0,59.0))
)

class Itinerary(lineName: String?, startStation: Point?, 
                endStation: Point?, totalTime: Double) {
  val lineName = lineName
  val startStation = startStation
  val endStation = endStation
  val totalTime = totalTime
}

class Listing(name: String, point: Point) {
  val name = name
  val point = point
  var itinerary: Itinerary? = null
}

// // The task is to sort this array of listings by subway distance:
val listings: MutableList<Listing> = mutableListOf(
  Listing("Alphabet City", Point(0.0,3.0)),
  Listing("Hudson Yards", Point(11.0,34.0)),
  Listing("Times Square", Point(7.0,42.0)),
  Listing("Chelsea", Point(9.0,22.0)),
  Listing("Tompkins Square", Point(0.0,10.0)),
  Listing("East Village", Point(2.0,7.5)),
  Listing("Washington Square", Point(5.0,6.0)),
  Listing("Empire State", Point(5.0,34.0)),
  Listing("Grand Central", Point(3.75,42.0)),
  Listing("Kips Bay", Point(1.0,33.0)),
  Listing("Hell's Kitchen", Point(9.0,55.0))
)

// Returns the east/west distance in miles between two points.
fun avenueDistance(pointA: Point, pointB: Point): Double {
  return (pointA.first - pointB.first).absoluteValue * avenueBlock
}
        
// Returns the north/south distance in miles between two points.
fun streetDistance(pointA: Point, pointB: Point): Double {
  return (pointA.second - pointB.second).absoluteValue * streetBlock
}

// Minutes to walk between two points along the street grid.
fun walkingTime(pointA: Point, pointB: Point): Double {
  val dx = avenueDistance(pointA, pointB)
  val dy = streetDistance(pointA, pointB)
  return (dx + dy) / walkingSpeed * 60.0
}

// Minutes for a train to go between two adjacent stations on a line,
// which could go diagonally under the street grid.
fun subwayTime(stationA: Point, stationB: Point): Double {
  val dx = avenueDistance(stationA, stationB)
  val dy = streetDistance(stationA, stationB)
  return sqrt(dx * dx + dy * dy) / subwaySpeed * 60.0
}

// // Time to go down a subway line between stations at certain indexes.
fun subwayJourneyTime(line: Line, start: Int, end: Int): Double {
  var startIndex = start
  var endIndex = end
  var time = entryTime
  
  if (startIndex > endIndex) {
    startIndex = endIndex.also { endIndex = startIndex }
  }
  for (a in startIndex..(endIndex - 1)) {
    val b = a + 1
    time += subwayTime(line.get(a), line.get(b))
    if (b != endIndex) {
      time += dwellTime
    }    
  }
  
  time += exitTime
  return time
}

// The index of a station on a line that is nearest to a given point.
fun indexOfNearestStation(line: Line, point: Point): Int {
    var bestIndex = -1
    var bestTime = -1.0
  
    for ((i, station) in line.iterator().withIndex()) {
      val time = walkingTime(station, point)
      if (bestIndex == -1 || time < bestTime) {
        bestIndex = i
        bestTime = time
      }
    }
  
    return bestIndex
}

fun itineraryForLine(home: Point, lineName: String, office: Point): Itinerary {
  val line: Line = lines.get(lineName)!!
  val startIndex = indexOfNearestStation(line, home)
  val endIndex = indexOfNearestStation(line, office)
  val startStation = line.get(startIndex)
  val endStation = line.get(endIndex)
  val startWalkTime = walkingTime(home, startStation)
  val endWalkTime = walkingTime(endStation, office)
  val subwayTime = subwayJourneyTime(line, startIndex, endIndex)
  val totalTime = startWalkTime + subwayTime + endWalkTime
  return Itinerary(lineName, startStation, endStation, totalTime)
}

fun printItinerary(itinerary: Itinerary?): String {
  return itinerary?.let {
    val totalTime = itinerary.totalTime.roundToInt()
    val lineName = itinerary.lineName
    return lineName?.let {
      val startStation = itinerary.startStation
      val endStation = itinerary.endStation
      return "$lineName train from $startStation to $endStation - $totalTime min"
    } ?: "just walk - $totalTime min"
  } ?: ""
}

fun main(args: Array<String>) {
  for (listing in listings) {
    var itineraries = mutableListOf<Itinerary>()
    for ((lineName, _) in lines) {
      itineraries.add(itineraryForLine(listing.point, lineName, compass))
    }
    val justWalk = walkingTime(listing.point, compass)
    itineraries.add(Itinerary(null, null, null, justWalk))
    itineraries.sortBy { it.totalTime }
    listing.itinerary = itineraries.get(0)
  }
  listings.sortBy { it.itinerary!!.totalTime }
  for (listing in listings) {
    val name = listing.name
    val itineraryString = printItinerary(listing.itinerary)
    println("$name - $itineraryString") 
  }
}

