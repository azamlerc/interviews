// Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

// Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as (blocks west of Ave A, blocks north of Houston). For example, the coordinates for the Compass office are (5,14) because it is at the intersection of 5 Av and 14 St. 

// Visualization:
// http://www.zamler-carhart.com/andrew/subway.html

#include <algorithm>
#include <iostream>
#include <string>
#include <vector>
#include <math.h>

using namespace std;
using std::vector;

class Point;
class Line;
class Listing;
class Itinerary;

// A point on the map at the intersection of an avenue and a street
class Point {
  public:
  
  double avenue;
  double street;

  static constexpr double avenueBlock = 0.17; // miles
  static constexpr double streetBlock = 0.05; // miles
  static constexpr double walkingSpeed = 3.0; // miles per hour
  static constexpr double subwaySpeed = 17.0; // miles per hour

  // Returns the east/west distance in miles between two points.
  static double avenueDistance(Point pointA, Point pointB) {
    return abs(pointA.avenue - pointB.avenue) * avenueBlock;
  }

  // Returns the north/south distance in miles between two points.
  static double streetDistance(Point pointA, Point pointB) {
    return abs(pointA.street - pointB.street) * streetBlock;
  }

  // Minutes to walk between two points along the street grid.
  static double walkingTime(Point pointA, Point pointB) {
    double dx = avenueDistance(pointA, pointB);
    double dy = streetDistance(pointA, pointB);
    return (dx + dy) / walkingSpeed * 60.0;
  }

  // Minutes for a train to go between two adjacent stations on a line,
  // which could go diagonally under the street grid.
  static double subwayTime(Point stationA, Point stationB) {
    double dx = avenueDistance(stationA, stationB);
    double dy = streetDistance(stationA, stationB);
    return sqrt(dx * dx + dy * dy) / subwaySpeed * 60.0;
  }
  
  Point() {
    avenue = 0;
    street = 0;
  }
  
  Point(double a, double s) { 
    avenue = a; 
    street = s; 
  } 

  string to_string() {
    return "(" + std::to_string((int)avenue) + "," + std::to_string((int)street) + ")";
  }

};

// A subway line, with a name and a list of stations
class Line {
  public: 
  
  string name;
  vector<Point> stations;
 
  static constexpr double entryTime = 3.0; 
  static constexpr double dwellTime = 0.5;
  static constexpr double exitTime = 1.0; 

  // Time to go down the line between stations at certain indexes.
  double subwayJourneyTime(int startIndex, int endIndex) {
    double time = entryTime;

    // if going downtown, swap the stations
    if (startIndex > endIndex) {
      swap(startIndex, endIndex);
    }
    for (int a = startIndex; a < endIndex; a++) {
      int b = a + 1;
      time += Point::subwayTime(stations[a], stations[b]);
      // don't need to wait for the train to leave the end station
      if (b != endIndex) time += dwellTime;
    }

    time += exitTime;
    return time;
  }

  // The index of a station that is nearest to a given point.
  int indexOfNearestStation(Point point) {
    int bestIndex = -1;
    double bestTime = -1;
  
    for (unsigned int i = 0; i < stations.size(); i++) {
      double time = Point::walkingTime(stations[i], point);
      if (bestIndex == -1 || time < bestTime) {
        bestIndex = i;
        bestTime = time;
      }
    }
  
    return bestIndex;
  }
  
  Line(string n, double coordsArray [][2]) {
    name = n;
    
    int size = sizeof(double (*)[2]) / sizeof(double [2]);
    for (int i = 0; i < size; i++) {
      stations.push_back(Point(coordsArray[i][0], coordsArray[i][1]));
    }
  }
  
  Itinerary calculateItinerary(Point home, Point office);
  
  // initializer
  Line(string n, vector<Point> ss) {
    name = n;
    stations = ss;
  }
};

class Itinerary {
  public: 
  
  string lineName;
  Point startStation;
  Point endStation;
  double totalTime = 0;
  
  string to_string() {
    if (lineName == "Just walk") {
      return "Just walk - " + std::to_string(totalTime) + " min";  
    } else {
      return lineName + " train from " + startStation.to_string() + " to " + endStation.to_string() + " - " + std::to_string(totalTime) + " min";  
    }
  }
  
  bool operator < (const Itinerary& i) const {
    return (totalTime < i.totalTime);
  }
};

class Listing {
  public: 
  
  string name;
  Point point;
  Itinerary itinerary;
 
  Listing(string n, Point p) {
    name = n;
    point = p;
  }

  string to_string() {
    if (itinerary.totalTime == 0) {
      return name + " - " + point.to_string();
    } else {
      return name + " - " + point.to_string() + " - " + itinerary.to_string();
    }
  }

  bool operator < (const Listing& l) const {
    return (itinerary.totalTime < l.itinerary.totalTime);
  }
};

Itinerary Line::calculateItinerary(Point home, Point office) {
  Itinerary i;

  i.lineName = name;
  int startIndex = indexOfNearestStation(home);
  int endIndex = indexOfNearestStation(office);
  i.startStation = stations[startIndex];
  i.endStation = stations[endIndex];
  double startWalkTime = Point::walkingTime(home, i.startStation);
  double endWalkTime = Point::walkingTime(i.endStation, office);
  double subwayTime = subwayJourneyTime(startIndex, endIndex);
  i.totalTime = startWalkTime + subwayTime + endWalkTime;

  return i;
}

int main() {
  Point compass = Point(5, 14);
  vector<Line> lines;
  vector<Listing> listings;

  lines.push_back(Line("1", {{7,0}, {7,4}, {7,14}, {7,18}, {7,23}, {7,28}, {7,34}, {7,42}, {7,50}, {8,59}}));
  lines.push_back(Line("2", {{7,14}, {7,34}, {7,42}}));
  lines.push_back(Line("4", {{4,14}, {3.75,42}, {3.5,59}}));
  lines.push_back(Line("6", {{3.5,0}, {4,8}, {4,14}, {4,23}, {4,28}, {4,33}, {3.75,42}, {3.5,51}, {3.5,59}}));
  lines.push_back(Line("A", {{6,4}, {8,14}, {8,34}, {8,42}, {8,59}}));
  lines.push_back(Line("C", {{6,4}, {8,14}, {8,23}, {8,34}, {8,42}, {8,50}, {8,59}}));
  lines.push_back(Line("D", {{3.5,0}, {6,4}, {6,34}, {6,42}, {6,47}, {7,53}, {8,59}}));
  lines.push_back(Line("F", {{2,0}, {3.5,0}, {6,4}, {6,14}, {6,23}, {6,34}, {6,42}, {6,47}, {6,57}}));
  lines.push_back(Line("L", {{1,14}, {3,14}, {4,14}, {6,14}, {8,14}}));
  lines.push_back(Line("M", {{3.5,0}, {6,4}, {6,14}, {6,23}, {6,34}, {6,42}, {6,47}, {5,53}, {3,53}}));
  lines.push_back(Line("Q", {{4,14}, {6,34}, {7,42}, {7,57}, {5,59}}));
  lines.push_back(Line("R", {{4,8}, {4,14}, {5,23}, {5.5,28}, {6,34}, {7,42}, {7,49}, {7,57}, {5,59}}));
  
  listings.push_back(Listing("Alphabet City", Point(0, 3)));
  listings.push_back(Listing("Hudson Yards", Point(11,34))); 
  listings.push_back(Listing("Times Square", Point(7,42))); 
  listings.push_back(Listing("Chelsea", Point(9,22))); 
  listings.push_back(Listing("Tompkins Square", Point(0,10))); 
  listings.push_back(Listing("East Village", Point(2,7.5))); 
  listings.push_back(Listing("Washington Square", Point(5,6))); 
  listings.push_back(Listing("Empire State", Point(5,34))); 
  listings.push_back(Listing("Grand Central", Point(3.75,42))); 
  listings.push_back(Listing("Kips Bay", Point(1,33))); 
  listings.push_back(Listing("Hell's Kitchen", Point(9,55)));     

  // Your solution here
  // Calcualte the best itinerary for each listing
  // Also consider that it may be faster to walk

  for (auto & listing : listings) {
    vector<Itinerary> itineraries;
    for (auto line : lines) {
      Itinerary itinerary = line.calculateItinerary(listing.point, compass);
      itineraries.push_back(itinerary);
      
    }
  
    Itinerary justWalk;
    justWalk.lineName = "Just walk";
    justWalk.totalTime = Point::walkingTime(listing.point, compass);
    itineraries.push_back(justWalk);

    std::sort(itineraries.begin(), itineraries.end());
    listing.itinerary = itineraries[0];
  }
        
  std::sort(listings.begin(), listings.end());
  for (auto listing : listings) {
    cout << listing.to_string() + "\n";
  }
 
  return 0;
}