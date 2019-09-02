// Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

// Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as (blocks west of Ave A, blocks north of Houston). For example, the coordinates for the Compass office are (5,14) because it is at the intersection of 5 Av and 14 St. 

import java.io.*;
import java.util.*;

// A point on the map at the intersection of an avenue and a street
class Point {
  double avenue;
  double street;
  
  static final double avenueBlock = 0.17; // miles
  static final double streetBlock = 0.05; // miles
  static final double walkingSpeed = 3.0; // miles per hour
  static final double subwaySpeed = 17.0; // miles per hour

  // Returns the east/west distance in miles between two points.
  public static double avenueDistance(Point pointA, Point pointB) {
    return Math.abs(pointA.avenue - pointB.avenue) * avenueBlock;
  }

  // Returns the north/south distance in miles between two points.
  public static double streetDistance(Point pointA, Point pointB) {
    return Math.abs(pointA.street - pointB.street) * streetBlock;
  }

  // Minutes to walk between two points along the street grid.
  public static double walkingTime(Point pointA, Point pointB) {
    var dx = avenueDistance(pointA, pointB);
    var dy = streetDistance(pointA, pointB);
    return (dx + dy) / walkingSpeed * 60.0;
  }

  // Minutes for a train to go between two adjacent stations on a line,
  // which could go diagonally under the street grid.
  public static double subwayTime(Point stationA, Point stationB) {
    var dx = avenueDistance(stationA, stationB);
    var dy = streetDistance(stationA, stationB);
    return Math.sqrt(dx * dx + dy * dy) / subwaySpeed * 60.0;
  }
  
  // Initializes a point from a string like "(5,14)"
  Point(String string) {
    string = string.substring(1,string.length() - 1);
    string = string.replace(","," ");
    Scanner scanner = new Scanner(string);
    scanner.useLocale(Locale.US);
    this.avenue = scanner.nextDouble();
    this.street = scanner.nextDouble();
    scanner.close();
  }
  
  public String toString() {
    return String.format("(%.0f,%.0f)", this.avenue, this.street);
  }
}

// A subway line, with a name and a list of stations
class Line {
  String name;
  ArrayList<Point> stations;
 
  static final double entryTime = 3.0; 
  static final double dwellTime = 0.5;
  static final double exitTime = 1.0; 

  // Time to go down the line between stations at certain indexes.
  public double subwayJourneyTime(int startIndex, int endIndex) {
    double time = entryTime;

    // if going downtown, swap the stations
    if (startIndex > endIndex) {
      int temp = startIndex;
      startIndex = endIndex;
      endIndex = temp;
    }
    for (int a = startIndex; a < endIndex; a++) {
      int b = a + 1;
      time += Point.subwayTime(stations.get(a), stations.get(b));
      // don't need to wait for the train to leave the end station
      if (b != endIndex) time += dwellTime;
    }

    time += exitTime;
    return time;
  }

  // The index of a station that is nearest to a given point.
  public int indexOfNearestStation(Point point) {
    int bestIndex = -1;
    double bestTime = -1;
  
    for (int i = 0; i < stations.size(); i++) {
      double time = Point.walkingTime(stations.get(i), point);
      if (bestIndex == -1 || time < bestTime) {
        bestIndex = i;
        bestTime = time;
      }
    }
  
    return bestIndex;
  }
  
  public Itinerary calculateItinerary(Point home, Point office) {
    Itinerary i = new Itinerary();
    
    // Your solution here
    // Calculate the best itinerary for taking this line

//     i.line = this;
//     int startIndex = indexOfNearestStation(home);
//     int endIndex = indexOfNearestStation(office);
//     i.startStation = stations.get(startIndex);
//     i.endStation = stations.get(endIndex);
//     double startWalkTime = Point.walkingTime(home, i.startStation);
//     double endWalkTime = Point.walkingTime(i.endStation, office);
//     double subwayTime = subwayJourneyTime(startIndex, endIndex);
//     i.totalTime = startWalkTime + subwayTime + endWalkTime;
 
    return i;
  }
  
  // initializer
  Line(String name, String stationsString) {
    this.name = name;
    this.stations = new ArrayList<>();
    
    ArrayList<String> pointStrings = new ArrayList<String>(Arrays.asList(stationsString.split(", ")));
    for (String pointString : pointStrings) {
      stations.add(new Point(pointString)); 
    }
  }
}

class Listing implements Comparable<Listing> {
  String name;
  Point point;
  Itinerary itinerary;
 
  Listing(String name, String pointString) {
    this.name = name;
    this.point = new Point(pointString);
  }

  public String toString() {
    if (itinerary == null) {
      return String.format("%s - %s", name, point); 
    } else {
      return String.format("%s - %s - %s", name, point, itinerary); 
    }
  }
  
  @Override
  public int compareTo(Listing other) {
    double thisTime = this.itinerary != null ? this.itinerary.totalTime : 0;
    double otherTime = other.itinerary != null ? other.itinerary.totalTime : 0;
    return (int) Math.round(thisTime - otherTime);
  }
}

class Itinerary implements Comparable<Itinerary> {
  Line line;
  Point startStation;
  Point endStation;
  double totalTime;
  
  public String toString() {
    if (totalTime > 0 && line == null) {
      return String.format("just walk - %.1f min", totalTime); 
    } else if (totalTime > 0 && line != null) {
      return String.format("%s train from %s to %s - %.1f min", line.name, startStation, endStation, totalTime);
    } else {
      return "?";
    }
  }
  
  @Override
  public int compareTo(Itinerary other) {
    return (int) Math.round(this.totalTime - other.totalTime);
  }
}

class Solution {
  static Point compass = new Point("(5,14)");
  static ArrayList<Line> lines = new ArrayList<>();
  static ArrayList<Listing> listings = new ArrayList<>();
  
  public static void main(String[] args) {
    
    lines.add(new Line("1", "(7,0), (7,4), (7,14), (7,18), (7,23), (7,28), (7,34), (7,42), (7,50), (8,59)"));
    lines.add(new Line("2", "(7,14), (7,34), (7,42)"));
    lines.add(new Line("4", "(4,14), (3.75,42), (3.5,59)"));
    lines.add(new Line("6", "(3.5,0), (4,8), (4,14), (4,23), (4,28), (4,33), (3.75,42), (3.5,51), (3.5,59)"));
    lines.add(new Line("A", "(6,4), (8,14), (8,34), (8,42), (8,59)"));
    lines.add(new Line("C", "(6,4), (8,14), (8,23), (8,34), (8,42), (8,50), (8,59)"));
    lines.add(new Line("D", "(3.5,0), (6,4), (6,34), (6,42), (6,47), (7,53), (8,59)"));
    lines.add(new Line("F", "(2,0), (3.5,0), (6,4), (6,14), (6,23), (6,34), (6,42), (6,47), (6,57)"));
    lines.add(new Line("L", "(1,14), (3,14), (4,14), (6,14), (8,14)"));
    lines.add(new Line("M", "(3.5,0), (6,4), (6,14), (6,23), (6,34), (6,42), (6,47), (5,53), (3,53)"));
    lines.add(new Line("Q", "(4,14), (6,34), (7,42), (7,57), (5,59)"));
    lines.add(new Line("R", "(4,8), (4,14), (5,23), (5.5,28), (6,34), (7,42), (7,49), (7,57), (5,59)"));

    listings.add(new Listing("Alphabet City", "(0,3)"));
    listings.add(new Listing("Hudson Yards", "(11,34)"));
    listings.add(new Listing("Times Square", "(7,42)"));
    listings.add(new Listing("Chelsea", "(9,22)"));
    listings.add(new Listing("Tompkins Square", "(0,10)"));
    listings.add(new Listing("East Village", "(2,7.5)"));
    listings.add(new Listing("Washington Square", "(5,6)"));
    listings.add(new Listing("Empire State", "(5,34)"));
    listings.add(new Listing("Grand Central", "(3.75,42)"));
    listings.add(new Listing("Kips Bay", "(1, 33)"));
    listings.add(new Listing("Hell's Kitchen", "(9,55)"));
    
    // Your solution here
    // Calcualte the best itinerary for each listing
    // Also consider that it may be faster to walk
    
//     for (Listing listing : listings) {
//       ArrayList<Itinerary> itineraries = new ArrayList<>();
//       for (Line line : lines) {
//         itineraries.add(line.calculateItinerary(listing.point, compass));
//       }
      
//       Itinerary justWalk = new Itinerary();
//       justWalk.totalTime = Point.walkingTime(listing.point, compass);
//       itineraries.add(justWalk);
      
//       Collections.sort(itineraries);
//       listing.itinerary = itineraries.get(0);
//     }
    
    Collections.sort(listings);
    for (Listing listing : listings) {
      System.out.println(listing);
    }
  }
}
