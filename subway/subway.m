// Write a program to calculate the time that it would take to commute from an apartment to the Compass office using the New York City Subway. You can walk to a station, take a train to another station, and from there walk to the office. You cannot transfer between trains.

// Take a section of the Manhattan street grid bounded by Ave A to 11 Av, and Houston St to 59 St. We can express coordinates as (blocks west of Ave A, blocks north of Houston). For example, the coordinates for the Compass office are (5,14) because it is at the intersection of 5 Av and 14 St. 

// Visualization:
// https://andrewzc.net/subway.html

#import <Foundation/Foundation.h>
#import <stdio.h>

double avenueBlock = 0.17; // miles
double streetBlock = 0.05; // miles
double walkingSpeed = 3.0; // miles per hour
double subwaySpeed = 17.0; // miles per hour
double entryTime = 3.0; // minutes to enter station and catch train
double dwellTime = 0.5; // minutes to wait in each intermediate station
double exitTime = 1.0; // minutes to exit station

@class Itinerary;

@interface Point: NSObject

@property double avenue;
@property double street;

+ (Point *) pointFromArray: (NSArray *) array;
+ (double) avenueDistanceFrom: (Point *) pointA 
                           to: (Point *) pointB;
+ (double) streetDistanceFrom: (Point *) pointA 
                           to: (Point *) pointB;
+ (double) walkingTimeFrom: (Point *) pointA 
                        to: (Point *) pointB;
+ (double) subwayTimeFrom: (Point *) pointA 
                       to: (Point *) pointB;

@end 

@interface Line: NSObject

@property NSString *name;
@property NSMutableArray *stations;

+ (Line *) lineWithName: (NSString *) name 
              stations: (NSArray *) pointArrays;
- (double) subwayJourneyTimeFrom: (int) startIndex 
                              to: (int) endIndex;
- (int) indexOfStationNearestTo: (Point *) point;
// TODO: implement this method
- (Itinerary *) calculateItineraryFrom: (Point *) pointA 
                                    to: (Point *) pointB;
@end 

@interface Itinerary: NSObject

@property Line *line;
@property Point *startStation;
@property Point *endStation;
@property double totalTime;

@end 

@interface Listing: NSObject

@property NSString *name;
@property Point *point;
@property Itinerary *itinerary;

+ (Listing *) listingWithName: (NSString *) name 
                        point: (NSArray *) pointArray;

@end 

@interface SubwayDistance: NSObject

@property Point *compass;
@property NSArray *lines;
@property NSMutableArray *listings;

// TODO: implement this method
- (Itinerary *) calculateItineraryFrom: (Point *) pointA 
                                    to: (Point *) pointB;
- (void) compareListings;

@end 


@implementation Point

+ (Point *) pointFromArray: (NSArray *) array {
  Point *point = [[Point alloc] init];
  point.avenue = ((NSNumber *) array[0]).doubleValue;
  point.street = ((NSNumber *) array[1]).doubleValue;
  return point;
}

// Returns the east/west distance in miles between two points.
+ (double) avenueDistanceFrom: (Point *) pointA 
                           to: (Point *) pointB {
  return fabs(pointA.avenue - pointB.avenue) * avenueBlock;
}
        
// Returns the north/south distance in miles between two points.
+ (double) streetDistanceFrom: (Point *) pointA 
                           to: (Point *) pointB {
  return fabs(pointA.street - pointB.street) * streetBlock;
}

// Minutes to walk between two points along the street grid.
+ (double) walkingTimeFrom: (Point *) pointA 
                        to: (Point *) pointB {
  double dx = [self avenueDistanceFrom: pointA to: pointB];
  double dy = [self streetDistanceFrom: pointA to: pointB];
  return (dx + dy) / walkingSpeed * 60.0;
}

// Minutes for a train to go between two adjacent stations on a line,
// which could go diagonally under the street grid.
+ (double) subwayTimeFrom: (Point *) pointA 
                       to: (Point *) pointB {
  double dx = [self avenueDistanceFrom: pointA to: pointB];
  double dy = [self streetDistanceFrom: pointA to: pointB];
  return sqrt(dx * dx + dy * dy) / subwaySpeed * 60.0;
}

- (NSString *) description {
  return [NSString stringWithFormat: @"(%.0f,%.0f)",
    self.avenue, self.street];
}

@end 

@implementation Line

+ (Line *) lineWithName: (NSString *) name 
               stations: (NSArray *) pointArrays
{
  Line *line = [[Line alloc] init];
  line.name = name;
  line.stations = [NSMutableArray array];

  for (NSArray *pointArray in pointArrays) {
    [line.stations addObject: [Point pointFromArray: pointArray]];
  }

  return line;
}

// Time to go down a subway line between stations at certain indexes.
- (double) subwayJourneyTimeFrom: (int) startIndex 
                              to: (int) endIndex
{
  double time = entryTime;
  
  if (startIndex > endIndex) {
    int temp = startIndex;
    startIndex = endIndex;
    endIndex = temp;
  }
  for (int a = startIndex; a < endIndex; a++) {
    int b = a + 1;
    time += [Point subwayTimeFrom: self.stations[a] to: self.stations[b]];
    if (b != endIndex) {
      time += dwellTime;
    }
  }
  
  time += exitTime;
  return time;
}

  // The index of a station that is nearest to a given point.
- (int) indexOfStationNearestTo: (Point *) point {
  int bestIndex = -1;
  double bestTime = -1;

  for (int i = 0; i < [self.stations count]; i++) {
    double time = [Point walkingTimeFrom: self.stations[i] to: point];
    if (bestIndex == -1 || time < bestTime) {
      bestIndex = i;
      bestTime = time;
    }
  }

  return bestIndex;
}

// TODO: implement this method
// Calculate the best itinerary for taking this line
- (Itinerary *) calculateItineraryFrom: (Point *) pointA 
                                    to: (Point *) pointB 
{
  Itinerary *itinerary = [[Itinerary alloc] init];

  itinerary.line = self;
  int startIndex = [self indexOfStationNearestTo: pointA];
  int endIndex = [self indexOfStationNearestTo: pointB];
  itinerary.startStation = self.stations[startIndex];
  itinerary.endStation = self.stations[endIndex];
  double startWalkTime = [Point walkingTimeFrom: pointA 
                                             to: itinerary.startStation];
  double endWalkTime = [Point walkingTimeFrom: itinerary.endStation 
                                           to: pointB];
  double subwayTime = [self subwayJourneyTimeFrom: startIndex 
                                               to: endIndex];
  itinerary.totalTime = startWalkTime + subwayTime + endWalkTime;
  
  return itinerary;
}

- (NSString *) description {
  return self.name;
}

@end

@implementation Itinerary

- (NSString *) description {
  if (self.line) {
    return [NSString stringWithFormat: @"%@ train from %@ to %@: %.2f min",
      self.line, self.startStation, self.endStation, self.totalTime];
  } else {
    return [NSString stringWithFormat: @"just walk: %.2f min",
      self.totalTime];
  }
}

@end 

@implementation Listing

+ (Listing *) listingWithName: (NSString *) name 
                        point: (NSArray *) pointArray 
{
  Listing *listing = [[Listing alloc] init];
  listing.name = name;
  listing.point = [Point pointFromArray: pointArray];
  return listing;
}

- (NSString *) description {
  if (self.itinerary) {
    return [NSString stringWithFormat: @"%@: %@",
    self.name, self.itinerary];

  } else {
    return self.name;
  }
}

@end

@implementation SubwayDistance

- init {
  self = [super init];
  
  self.compass = [Point pointFromArray: @[@5, @14]];
  
  self.lines = @[
    [Line lineWithName: @"1" stations: @[@[@7, @0], @[@7, @4], @[@7, @14], @[@7, @18], @[@7, @23], @[@7, @28], @[@7, @34], @[@7, @42], @[@7, @50], @[@8, @59]]],
    [Line lineWithName: @"2" stations: @[@[@7, @14], @[@7, @34], @[@7, @42]]],
    [Line lineWithName: @"4" stations: @[@[@4, @14], @[@3.75, @42], @[@3.5, @59]]],
    [Line lineWithName: @"6" stations: @[@[@3.5, @0], @[@4, @8], @[@4, @14], @[@4, @23], @[@4, @28], @[@4, @33], @[@3.75, @42], @[@3.5, @51], @[@3.5, @59]]],
    [Line lineWithName: @"A" stations: @[@[@6, @4], @[@8, @14], @[@8, @34], @[@8, @42], @[@8, @59]]],
    [Line lineWithName: @"C" stations: @[@[@6, @4], @[@8, @14], @[@8, @23], @[@8, @34], @[@8, @42], @[@8, @50], @[@8, @59]]],
    [Line lineWithName: @"D" stations: @[@[@3.5, @0], @[@6, @4], @[@6, @34], @[@6, @42], @[@6, @47], @[@7, @53], @[@8, @59]]],
    [Line lineWithName: @"F" stations: @[@[@2, @0], @[@3.5, @0], @[@6, @4], @[@6, @14], @[@6, @23], @[@6, @34], @[@6, @42], @[@6, @47], @[@6, @57]]],
    [Line lineWithName: @"L" stations: @[@[@1, @14], @[@3, @14], @[@4, @14], @[@6, @14], @[@8, @14]]],
    [Line lineWithName: @"M" stations: @[@[@3.5, @0], @[@6, @4], @[@6, @14], @[@6, @23], @[@6, @34], @[@6, @42], @[@6, @47], @[@5, @53], @[@3, @53]]],
    [Line lineWithName: @"Q" stations: @[@[@4, @14], @[@6, @34], @[@7, @42], @[@7, @57], @[@5, @59]]],
    [Line lineWithName: @"R" stations: @[@[@4, @8], @[@4, @14], @[@5, @23], @[@5.5, @28], @[@6, @34], @[@7, @42], @[@7, @49], @[@7, @57], @[@5, @59]]]
  ];
  
  self.listings = [@[
    [Listing listingWithName: @"Alphabet City" point: @[@0,@3]],
    [Listing listingWithName: @"Hudson Yards" point: @[@11,@34]],
    [Listing listingWithName: @"Times Square" point: @[@7,@42]],
    [Listing listingWithName: @"Chelsea" point: @[@9,@22]],
    [Listing listingWithName: @"Tompkins Square" point: @[@0,@10]],
    [Listing listingWithName: @"East Village" point: @[@2,@7.5]],
    [Listing listingWithName: @"Washington Square" point: @[@5,@6]],
    [Listing listingWithName: @"Empire State" point: @[@5,@34]],
    [Listing listingWithName: @"Grand Central" point: @[@3.75,@42]],
    [Listing listingWithName: @"Kips Bay" point: @[@1, @33]],
    [Listing listingWithName: @"Hell's Kitchen" point: @[@9,@55]],
  ] mutableCopy];
  
  return self;
}

// TODO: implement this method
// Calculate the best itinerary for taking this line
- (Itinerary *) calculateItineraryFrom: (Point *) pointA 
                                    to: (Point *) pointB
{
  NSMutableArray *itineraries = [NSMutableArray array];
  Itinerary *justWalk = [[Itinerary alloc] init];
  justWalk.totalTime = [Point walkingTimeFrom: pointA to: pointB];
  [itineraries addObject: justWalk];

  for (Line *line in self.lines) {
    [itineraries addObject: 
      [line calculateItineraryFrom: pointA to: pointB]];
  }
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
    initWithKey:@"totalTime" ascending:YES];
  [itineraries sortUsingDescriptors: @[sortDescriptor]];
  
  return [itineraries firstObject];
}

- (void) compareListings {
  for (Listing *listing in self.listings) {
    listing.itinerary = 
      [self calculateItineraryFrom: self.compass to: listing.point];
  }
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
    initWithKey:@"itinerary.totalTime" ascending:YES];
  [self.listings sortUsingDescriptors: @[sortDescriptor]];

  for (Listing *listing in self.listings) {
    NSLog(@"%@", listing);
  }
}

@end 


int main (int argc, const char * argv[])
{
  @autoreleasepool {
    SubwayDistance *subway = [[SubwayDistance alloc] init];
    [subway compareListings];
  }
}

