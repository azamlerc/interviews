compass <- c(av=5, st=14)
avenueBlock <- 0.17 # miles
streetBlock <- 0.05 # miles
walkingSpeed <- 3.0 # miles per hour
subwaySpeed <- 17.0 # miles per hour
entryTime <- 3.0 # minutes to enter station and catch train
dwellTime <- 0.5 # minutes to wait in each intermediate station
exitTime <- 1.0 # minutes to exit station

lines <- list()
lines[["1"]] <- data.frame(
  av = c(7,7,7,7,7,7,7,7,7,8),
  st = c(0,4,14,18,23,28,34,42,50,59))
lines[["2"]] <- data.frame(
  av = c(7,7,7),
  st = c(14,34,42))
lines[["4"]] <- data.frame(
  av = c(4,3.75,3.5),
  st = c(14,42,59))
lines[["6"]] <- data.frame(
  av = c(3.5,4,4,4,4,4,3.75,3.5,3.5),
  st = c(0,8,14,23,28,33,42,51,59))
lines[["A"]] <- data.frame(
  av = c(6,8,8,8,8),
  st = c(4,14,34,42,59))
lines[["C"]] <- data.frame(
  av = c(6,8,8,8,8,8,8),
  st = c(4,14,23,34,42,50,59))
lines[["D"]] <- data.frame(
  av = c(3.5,6,6,6,6,7,8),
  st = c(0,4,34,42,47,53,59))
lines[["F"]] <- data.frame(
  av = c(3,3.5,6,6,6,6,6,6,6),
  st = c(0,0,4,14,23,34,42,47,57))
lines[["L"]] <- data.frame(
  av = c(1,3,4,6,8),
  st = c(14,14,14,14,14))
lines[["M"]] <- data.frame(
  av = c(3.5,6,6,6,6,6,6,5,3),
  st = c(0,4,14,23,34,42,47,53,53))
lines[["Q"]] <- data.frame(
  av = c(4,6,7,7,5),
  st = c(14,34,42,57,59))
lines[["R"]] <- data.frame(
  av = c(4,4,5,5.5,6,7,7,7,5),
  st = c(8,14,23,28,34,42,49,57,59))

listings <- data.frame(
  name = c("Alphabet City", "Hudson Yards", "Times Square", "Chelsea", "Tompkins Square", "East Village", "Washington Square", "Empire State", "Grand Central", "Kips Bay", "Hell's Kitchen"),
  av = c(0,11,7,9,0,2,5,5,3.75,1,9),
  st = c(3,34,42,22,10,7.5,6,34,42,33,55))

# Returns the east/west distance in miles between two points.
avenueDistance <- function(pointA, pointB) {
  abs(pointA["av"] - pointB["av"]) * avenueBlock
}
        
# Returns the north/south distance in miles between two points.
streetDistance <- function(pointA, pointB) {
  abs(pointA["st"] - pointB["st"]) * streetBlock
}

# Minutes to walk between two points along the street grid.
walkingTime <- function (pointA, pointB) {
  dx <- avenueDistance(pointA, pointB)
  dy <- streetDistance(pointA, pointB)
  (dx + dy) / walkingSpeed * 60.0
}

# Minutes for a train to go between two adjacent stations on a line,
# which could go diagonally under the street grid.
subwayTime <- function(stationA, stationB) {
  dx <- avenueDistance(stationA, stationB)
  dy <- streetDistance(stationA, stationB)
  sqrt(dx * dx + dy * dy) / subwaySpeed * 60.0
}

# Time to go down a subway line between stations at certain indexes.
subwayJourneyTime <- function(line, startIndex, endIndex) {
  time <- entryTime
  lo <- min(startIndex, endIndex) 
  hi <- max(startIndex, endIndex) 
  
  for (a in lo:(hi-1)) {
    b <- a+1
    time <- time + subwayTime(line[a,], line[b,])
    if (b != hi) {
      time <- time + dwellTime
    }
  }
  unname(time + exitTime)
}

# The index of a station on a line that is nearest to a given point.
indexOfNearestStation <- function(line, point) {
    bestIndex <- -1
    bestTime <- -1
  
    for (i in 1:nrow(line)) {
      time <- walkingTime(line[i,], point)
      if (bestIndex == -1 | time < bestTime) {
        bestIndex <- i
        bestTime <- time
      }
    }
  
    bestIndex
}

itineraryForLine <- function(lineName, home, office) {
  i = list()
  i$lineName = lineName
  line <- lines[[lineName]]
  startIndex <- indexOfNearestStation(line, home)
  endIndex <- indexOfNearestStation(line, office)
  i$startStation <- line[startIndex,]
  i$endStation <- line[endIndex,]
  startWalkTime <- walkingTime(home, i$startStation)
  endWalkTime <- walkingTime(i$endStation, office)
  subwayTime <- subwayJourneyTime(line, startIndex, endIndex)
  i$totalTime <- startWalkTime + subwayTime + endWalkTime
  i
}

bestItinerary <- function(home, office) {
  itineraries <- data.frame()
}

printItinerary <- function(i) {
  if (length(i$lineName) == 0) {
    sprintf("just walk - %d min", i$totalTime)
  } else {
    sprintf("%s train from [%.0f,%.0f] to [%.0f,%.0f] - %.1f min", i$lineName, i$startStation$av, i$startStation$st, i$endStation$av, i$endStation$st, i$totalTime)
  }
}

for(i in 1:nrow(listings)) {
  listing <- listings[i, ]
}
  
  
printItinerary(itineraryForLine("1", c(av=9, st=55), compass))