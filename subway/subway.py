# Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

# Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as (blocks west of Ave A, blocks north of Houston). For example, the coordinates for the Compass office are (5,14) because it is at the intersection of 5 Av and 14 St. 

import math

COMPASS = (5,14)
AVENUE_BLOCK = 0.17 # miles
STREET_BLOCK = 0.05 # miles
WALKING_SPEED = 3.0 # miles per hour
SUBWAY_SPEED = 17.0 # miles per hour
ENTRY_TIME = 3.0 # minutes to enter station and catch train
DWELL_TIME = 0.5 # minutes to wait in each intermediate station
EXIT_TIME = 1.0 # minutes to exit station

# There are subway lines with stations at the following coordinates:
LINES = {
  '1': [(7,0), (7,4), (7,14), (7,18), (7,23), 
        (7,28), (7,34), (7,42), (7,50), (8,59)],
  '2': [(7,14), (7,34), (7,42)],
  '4': [(4,14), (3.75,42), (3.5,59)],
  '6': [(3.5,0), (4,8), (4,14), (4,23), (4,28), 
        (4,33), (3.75,42), (3.5,51), (3.5,59)],
  'A': [(6,4), (8,14), (8,34), (8,42), (8,59)],
  'C': [(6,4), (8,14), (8,23), (8,34), (8,42), 
        (8,50), (8,59)],
  'D': [(3.5,0), (6,4), (6,34), (6,42), (6,47), 
        (7,53), (8,59)],
  'F': [(2,0), (3.5,0), (6,4), (6,14), (6,23), 
        (6,34), (6,42), (6,47), (6,57)],
  'L': [(1,14), (3,14), (4,14), (6,14), (8,14)],
  'M': [(3.5,0), (6,4), (6,14), (6,23), (6,34), 
        (6,42), (6,47), (5,53), (3,53)],
  'Q': [(4,14), (6,34), (7,42), (7,57), (5,59)],
  'R': [(4,8), (4,14), (5,23), (5.5,28), (6,34), 
        (7,42), (7,49), (7,57), (5,59)]
}

# The task is to sort this array of listings by subway distance:
listings = [
  {'name': "Alphabet City", 'point': (0,3)},
  {'name': "Hudson Yards", 'point': (11,34)},
  {'name': "Times Square", 'point': (7,42)},
  {'name': "Chelsea", 'point': (9,22)},
  {'name': "Tompkins Square", 'point': (0,10)},
  {'name': "East Village", 'point': (2,7.5)},
  {'name': "Washington Square", 'point': (5,6)},
  {'name': "Empire State", 'point': (5,34)},
  {'name': "Grand Central", 'point': (3.75,42)},
  {'name': "Kips Bay", 'point': (1, 33)},
  {'name': "Hell's Kitchen", 'point': (9,55)}
]
 
def printItinerary(itinerary):
    if not itinerary:
        return ''
    else:
        totalTime = round(itinerary['totalTime'])
        if totalTime and not 'lineName' in itinerary.keys():
            return f'just walk - {totalTime} min'
        else:
            lineName = itinerary['lineName']
            startStation = itinerary['startStation']
            endStation = itinerary['endStation']
            return f'{lineName} train from {startStation} to {endStation} - {totalTime} min'

def itineraryForLine(home, lineName, office):
    i = {'lineName': lineName}
    line = LINES[lineName]
    startIndex = indexOfNearestStation(line, home)
    endIndex = indexOfNearestStation(line, office)
    i['startStation'] = line[startIndex]
    i['endStation'] = line[endIndex]
    startWalkTime = walkingTime(home, i['startStation'])
    endWalkTime = walkingTime(i['endStation'], office)
    subwayTime = subwayJourneyTime(line, startIndex, endIndex)
    i['totalTime'] = startWalkTime + subwayTime + endWalkTime
    return i

# Returns the east/west distance in miles between two points.
def avenueDistance(pointA, pointB):
    return abs(pointA[0] - pointB[0]) * AVENUE_BLOCK
       
# Returns the north/south distance in miles between two points.
def streetDistance(pointA, pointB):
    return abs(pointA[1] - pointB[1]) * STREET_BLOCK

# Minutes to walk between two points along the street grid.
def walkingTime(pointA, pointB):
    dx = avenueDistance(pointA, pointB)
    dy = streetDistance(pointA, pointB)
    return (dx + dy) / WALKING_SPEED * 60.0

# Minutes for a train to go between two adjacent stations on a line,
# which could go diagonally under the street grid.
def subwayTime(stationA, stationB):
    dx = avenueDistance(stationA, stationB)
    dy = streetDistance(stationA, stationB)
    return math.sqrt(dx * dx + dy * dy) / SUBWAY_SPEED * 60.0

# Time to go down a subway line between stations at certain indexes.
def subwayJourneyTime(line, startIndex, endIndex):
    time = ENTRY_TIME

    if startIndex > endIndex:
        startIndex, endIndex = endIndex, startIndex
    for a in range (startIndex, endIndex): 
        b = a + 1
        time += subwayTime(line[a], line[b])
        if b != endIndex:
            time += DWELL_TIME

    time += EXIT_TIME
    return time

# The index of a station on a line that is nearest to a given point.
def indexOfNearestStation(line, point):
    bestIndex = -1
    bestTime = -1
    for i, station in enumerate(line):
        time = walkingTime(station, point)
        if bestIndex == -1 or time < bestTime:
            bestIndex = i
            bestTime = time
    return bestIndex

for listing in listings:
    itineraries = []
    for lineName, line in LINES.items():
        itineraries.append(itineraryForLine(listing['point'], lineName, COMPASS))
    itineraries.append({'totalTime': walkingTime(listing['point'], COMPASS)})
    itineraries.sort(key=lambda i: i['totalTime'])
    best = itineraries[0]
    listing['itinerary'] = best
    listing['totalTime'] = best['totalTime']
listings.sort(key=lambda l: l['totalTime'])
for listing in listings:
    print(listing['name'] + ' - ' + printItinerary(listing['itinerary']))

