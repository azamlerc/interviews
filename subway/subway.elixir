# Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

# Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as {blocks west of Ave A, blocks north of Houston}. For example, the coordinates for the Compass office are {5,14} because it is at the intersection of 5 Av and 14 St. 

# Visualization:
# http://www.zamler-carhart.com/andrew/subway.html

compass = {5,14}

lines = [
  [name: "1", stations: [{7,0}, {7,4}, {7,14}, {7,18}, {7,23}, {7,28}, {7,34}, {7,42}, {7,50}, {8,59}]],
  [name: "2", stations: [{7,14}, {7,34}, {7,42}]],
  [name: "4", stations: [{4,14}, {3.75,42}, {3.5,59}]],
  [name: "6", stations: [{3.5,0}, {4,8}, {4,14}, {4,23}, {4,28}, {4,33}, {3.75,42}, {3.5,51}, {3.5,59}]],
  [name: "A", stations: [{6,4}, {8,14}, {8,34}, {8,42}, {8,59}]],
  [name: "C", stations: [{6,4}, {8,14}, {8,23}, {8,34}, {8,42}, {8,50}, {8,59}]],
  [name: "D", stations: [{3.5,0}, {6,4}, {6,34}, {6,42}, {6,47}, {7,53}, {8,59}]],
  [name: "F", stations: [{2,0}, {3.5,0}, {6,4}, {6,14}, {6,23}, {6,34}, {6,42}, {6,47}, {6,57}]],
  [name: "L", stations: [{1,14}, {3,14}, {4,14}, {6,14}, {8,14}]],
  [name: "M", stations: [{3.5,0}, {6,4}, {6,14}, {6,23}, {6,34}, {6,42}, {6,47}, {5,53}, {3,53}]],
  [name: "Q", stations: [{4,14}, {6,34}, {7,42}, {7,57}, {5,59}]],
  [name: "R", stations: [{4,8}, {4,14}, {5,23}, {5.5,28}, {6,34}, {7,42}, {7,49}, {7,57}, {5,59}]]
]

listings = [
  [name: "Alphabet City", point: {0,3}],
  [name: "Hudson Yards", point: {11,34}],
  [name: "Times Square", point: {7,42}],
  [name: "Chelsea", point: {9,22}],
  [name: "Tompkins Square", point: {0,10}],
  [name: "East Village", point: {2,7.5}],
  [name: "Washington Square", point: {5,6}],
  [name: "Empire State", point: {5,34}],
  [name: "Grand Central", point: {3.75,42}],
  [name: "Kips Bay", point: {1, 33}],
  [name: "Hell's Kitchen", point: {9,55}]
]

# a point on the map at the intersection of an avenue and a street
defmodule Point do
  @avenueBlock 0.17 # miles
  @streetBlock 0.05 # miles
  @walkingSpeed 3.0 # miles per hour
  @subwaySpeed 17.0 # miles per hour

  # the east/west distance in miles between two points
  def avenueDistance(pointA, pointB) do
    abs(elem(pointA, 0) - elem(pointB, 0)) * @avenueBlock
  end

  # the north/south distance in miles between two points
  def streetDistance(pointA, pointB) do
    abs(elem(pointA, 1) - elem(pointB, 1)) * @streetBlock
  end

  # minutes to walk between two points along the street grid
  def walkingTime(pointA, pointB) do
    dx = Point.avenueDistance(pointA, pointB)
    dy = Point.streetDistance(pointA, pointB)
    (dx + dy) / @walkingSpeed * 60.0
  end

  # minutes for a train to go between two adjacent stations 
  # on a line, which could go diagonally under the street grid
  def subwayTime(stationA, stationB) do
    dx = Point.avenueDistance(stationA, stationB)
    dy = Point.streetDistance(stationA, stationB)
    :math.sqrt(dx * dx + dy * dy) / @subwaySpeed * 60.0
  end
  
  def to_s(point) do
    "(#{elem(point, 0)},#{elem(point, 1)})"
  end
end

# a subway line, with a name and a list of stations
defmodule Line do
  @entryTime 3.0 # time to enter a station and catch a train
  @dwellTime 0.5 # time to pass through a station
  @exitTime 1.0 # time to exit a station

  # Time to go down the line between stations at certain indexes.
  def subwayJourneyTime(stations, startIndex, endIndex) do
    minIndex = min(startIndex,endIndex)
    maxIndex = max(startIndex,endIndex)
    times = for a <- minIndex..maxIndex-1 do
      stationA = Enum.at(stations,a)
      stationB = Enum.at(stations,a + 1)
      Point.subwayTime(stationA, stationB) + @dwellTime
    end
    subwayTime = Enum.reduce(times, 0, fn(x, a) -> a + x end)
    @entryTime + subwayTime - @dwellTime + @exitTime
  end
  
  def indexOfNearestStation(stations, point) do
    stations
    |> Enum.with_index
    |> Enum.reduce({-1,0}, fn({station, i}, best) ->
      time = Point.walkingTime(station, point)
      if elem(best,0) == -1 || time < elem(best,1),
        do: {i, time}, else: best
      end)
    |> elem(0)
  end
end 
  
defmodule Itinerary do
  def calculateItinerary(line, home, office) do
    stations = line[:stations]
    startIndex = Line.indexOfNearestStation(stations, home)
    endIndex = Line.indexOfNearestStation(stations, office)
    startStation = Enum.at(stations, startIndex)
    endStation = Enum.at(stations, endIndex)
    startWalkTime = Point.walkingTime(home, startStation)
    endWalkTime = Point.walkingTime(endStation, office)
    subwayTime = Line.subwayJourneyTime(stations, startIndex, endIndex)
    totalTime = startWalkTime + subwayTime + endWalkTime
    [lineName: line[:name], startStation: startStation, 
      endStation: endStation, totalTime: totalTime]
  end
  
  def bestItinerary(lines, home, office) do
    walk = [lineName: "just walk", 
      totalTime: Point.walkingTime(home, office)]
    Enum.reduce(lines, walk, fn(line, best) -> 
      itinerary = Itinerary.calculateItinerary(line, home, office)
      if itinerary[:totalTime] < best[:totalTime],
        do: itinerary, else: best 
      end)
  end
end

listings 
  |> Enum.map(fn(listing) -> listing ++ 
    Itinerary.bestItinerary(lines, listing[:point], compass) end)
  |> Enum.sort(fn(l1, l2) -> l1[:totalTime] < l2[:totalTime] end)
  |> Enum.each(fn(l) -> IO.puts "#{l[:name]} - #{l[:lineName]}" <> (if l[:lineName] != "just walk", do: " train from #{Point.to_s(l[:startStation])} to #{Point.to_s(l[:endStation])}", else: "") <> " - #{round(l[:totalTime])} min" end)
