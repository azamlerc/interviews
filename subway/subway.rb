# Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

# Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as (blocks west of Ave A, blocks north of Houston). For example, the coordinates for the Compass office are (5,14) because it is at the intersection of 5 Av and 14 St. 

# Visualization:
# https://andrewzc.net/subway.html

# A point on the map at the intersection of an avenue and a street
class Point
  attr_accessor :avenue
  attr_accessor :street
  
  AvenueBlock = 0.17 # miles
  StreetBlock = 0.05 # miles
  WalkingSpeed = 3.0 # miles per hour
  SubwaySpeed = 17.0 # miles per hour
  
  def initialize(a, s)
    @avenue = a
    @street = s
  end
    
  # Returns the east/west distance in miles between two points.
  def self.avenueDistance(pointA, pointB)
    return (pointA.avenue - pointB.avenue).abs * AvenueBlock
  end

  # Returns the north/south distance in miles between two points.
  def self.streetDistance(pointA, pointB)
    return (pointA.street - pointB.street).abs * StreetBlock
  end

  # Minutes to walk between two points along the street grid.
  def self.walkingTime(pointA, pointB)
    dx = Point.avenueDistance(pointA, pointB)
    dy = Point.streetDistance(pointA, pointB)
    return (dx + dy) / WalkingSpeed * 60.0
  end

  # Minutes for a train to go between two adjacent stations on a line,
  # which could go diagonally under the street grid.
  def self.subwayTime(stationA, stationB)
    dx = Point.avenueDistance(stationA, stationB)
    dy = Point.streetDistance(stationA, stationB)
    return Math.sqrt(dx * dx + dy * dy) / SubwaySpeed * 60.0
  end
  
  def to_s 
    return "(#{@avenue},#{@street})"
  end
end

# A subway line, with a name and a list of stations
class Line
  attr_accessor :name
  attr_accessor :stations

  EntryTime = 3.0 # time to enter a station and catch a train
  DwellTime = 0.5 # time to pass through a station
  ExitTime = 1.0 # time to exit a station

  def initialize(name, points)
    @name = name
    @stations = []
    
    points.each do |point| 
      @stations.push(Point.new(point[0], point[1]))
    end
  end

  # Time to go down the line between stations at certain indexes.
  def subwayJourneyTime(startIndex, endIndex)
    time = EntryTime

    # if going downtown, swap the stations
    if startIndex > endIndex
      startIndex, endIndex = endIndex, startIndex
    end
  
    for a in startIndex..endIndex-1
      b = a + 1
      time += Point.subwayTime(@stations[a], @stations[b])
      # don't need to wait for the train to leave the end station
      if b != endIndex
        time += DwellTime
      end
    end

    time += ExitTime
    return time
  end

  # The index of a station that is nearest to a given point.
  def indexOfNearestStation(point)
    bestIndex = -1
    bestTime = -1

    @stations.each_with_index do |station,i|
      time = Point.walkingTime(station, point)
      if bestIndex == -1 || time < bestTime
        bestIndex = i
        bestTime = time
      end
    end

    return bestIndex
  end

  def calculateItinerary(home, office)
    i = Itinerary.new

    # Your solution here
    # Calculate the best itinerary for taking this line
    
    i.lineName = @name
    startIndex = indexOfNearestStation(home)
    endIndex = indexOfNearestStation(office)
    i.startStation = @stations[startIndex]
    i.endStation = @stations[endIndex]
    startWalkTime = Point.walkingTime(home, i.startStation)
    endWalkTime = Point.walkingTime(i.endStation, office)
    subwayTime = subwayJourneyTime(startIndex, endIndex)
    i.totalTime = startWalkTime + subwayTime + endWalkTime

    return i
  end
end

class Listing
  attr_accessor :name
  attr_accessor :point
  attr_accessor :itinerary

  def initialize(name, point)
    @name = name
    @point = point
    @itinerary = nil
  end

  def to_s
    if itinerary == nil
      return "#{@name} - #{@point}"
    else
      return "#{@name} - #{@point} - #{@itinerary}"
    end
  end
end

class Itinerary
  attr_accessor :lineName
  attr_accessor :startStation
  attr_accessor :endStation
  attr_accessor :totalTime

  def to_s
    if lineName == nil
      return "just walk - #{totalTime} min"
    else
      return "#{lineName} train from #{startStation} to #{endStation} - #{totalTime.to_i} min"
    end
  end
end

compass = Point.new(5,14)

lines = {
  "1" => [[7,0], [7,4], [7,14], [7,18], [7,23], [7,28], [7,34], [7,42], [7,50], [8,59]],
  "2" => [[7,14], [7,34], [7,42]],
  "4" => [[4,14], [3.75,42], [3.5,59]],
  "6" => [[3.5,0], [4,8], [4,14], [4,23], [4,28], [4,33], [3.75,42], [3.5,51], [3.5,59]],
  "A" => [[6,4], [8,14], [8,34], [8,42], [8,59]],
  "C" => [[6,4], [8,14], [8,23], [8,34], [8,42], [8,50], [8,59]],
  "D" => [[3.5,0], [6,4], [6,34], [6,42], [6,47], [7,53], [8,59]],
  "F" => [[2,0], [3.5,0], [6,4], [6,14], [6,23], [6,34], [6,42], [6,47], [6,57]],
  "L" => [[1,14], [3,14], [4,14], [6,14], [8,14]],
  "M" => [[3.5,0], [6,4], [6,14], [6,23], [6,34], [6,42], [6,47], [5,53], [3,53]],
  "Q" => [[4,14], [6,34], [7,42], [7,57], [5,59]],
  "R" => [[4,8], [4,14], [5,23], [5.5,28], [6,34], [7,42], [7,49], [7,57], [5,59]]
}.map { |name, stations| Line.new(name, stations) }

listings = {
  "Alphabet City" => [0,3],
  "Hudson Yards" => [11,34],
  "Times Square" => [7,42],
  "Chelsea" => [9,22],
  "Tompkins Square" => [0,10],
  "East Village" => [2,7.5],
  "Washington Square" => [5,6],
  "Empire State" => [5,34],
  "Grand Central" => [3.75,42],
  "Kips Bay" => [1, 33],
  "Hell's Kitchen" => [9,55]
}.map { |name, p| Listing.new(name, Point.new(p[0], p[1])) }

# Your solution here
# Calcualte the best itinerary for each listing
# Also consider that it may be faster to walk

listings.each do |listing|
  bestItinerary = Itinerary.new
  bestItinerary.totalTime = Point.walkingTime(listing.point, compass)
  
  lines.each do |line|
    itinerary = line.calculateItinerary(listing.point, compass)
    if itinerary.totalTime < bestItinerary.totalTime
      bestItinerary = itinerary
    end
  end
  
  listing.itinerary = bestItinerary
end

listings
  .sort_by {|listing| listing.itinerary.totalTime}
  .each { |listing| puts listing }
