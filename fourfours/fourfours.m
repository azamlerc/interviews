// Four fours is a mathematical puzzle. The goal is to find a mathematical
// expression for every whole number from 1 to 100, using only common
// mathematical symbols and the number four four times.
//
// Problem: https://en.wikipedia.org/wiki/Four_fours
// Playground: https://andrewzc.net/fourfours/
//
// In this case, we will start with the initial values 4, .4, √4 and 4!
// and combine them using the operations addition, subtraction,
// multiplication and division.

#import <Foundation/Foundation.h>
#import <stdio.h>

float roundNumber(float num) {
    return round(1000000 * num) / 1000000;
}

@interface Solution: NSObject

@property NSMutableArray *fours;

- (void) calculateFours;
- (void) combineSet: (int) countA 
            withSet: (int) countB;
- (void) printFours;

@end

@implementation Solution

// Returns an array of sets of numbers that can be generated with 
// zero, one, two, three, or four of the number four.
- (void) calculateFours {
    self.fours = [NSMutableArray array];
  
    for (int i = 0; i <= 4; i++) {
      [self.fours addObject: [NSMutableSet set]];
    }    
    
    [self.fours[1] addObject: @0.4];
    [self.fours[1] addObject: @2.0]; // √4
    [self.fours[1] addObject: @4.0];
    [self.fours[1] addObject: @24.0]; // 4!
 
    // your solution here
    // calcualte fours[2], fours[3] and fours[4]

    [self combineSet: 1 withSet: 1];
    [self combineSet: 1 withSet: 2];
    [self combineSet: 1 withSet: 3];
    [self combineSet: 2 withSet: 2];
}

- (void) combineSet: (int) countA 
            withSet: (int) countB 
{
  NSMutableSet *newSet = self.fours[countA + countB];
  for (NSNumber *numberA in self.fours[countA]) {
    double valueA = [numberA doubleValue];
    for (NSNumber *numberB in self.fours[countB]) {
      double valueB = [numberB doubleValue];

      [newSet addObject: [NSNumber numberWithDouble: valueA + valueB]];
      [newSet addObject: [NSNumber numberWithDouble: valueA - valueB]];
      [newSet addObject: [NSNumber numberWithDouble: valueB - valueA]];
      [newSet addObject: [NSNumber numberWithDouble: valueA * valueB]];
    
      if (valueB != 0) {
        [newSet addObject: [NSNumber numberWithDouble: 
          roundNumber(valueA / valueB)]];
      }
      if (valueA != 0) {
        [newSet addObject: [NSNumber numberWithDouble: 
          roundNumber(valueB / valueA)]];
      }
    }
  }
}

- (void) printFours {
    NSArray *sortDescriptors = @[[[NSSortDescriptor alloc] 
      initWithKey:@"self" ascending:YES]];
    for (int count = 1; count <= 3; count++) {
      NSMutableArray *array = [[self.fours[count] allObjects] mutableCopy];
      [array sortUsingDescriptors: sortDescriptors];
      NSLog(@"%d fours: %@\n\n", count, array);
    }
    NSSet *set = self.fours[4];
    NSMutableArray *found = [NSMutableArray array];
    NSMutableArray *missing = [NSMutableArray array];
    for (int i = 1; i <= 100; i++) {
      NSNumber *number = [NSNumber numberWithDouble: i];
      if ([set containsObject: number]) {
        [found addObject: number];
      } else {
        [missing addObject: number];
      }
    }
    NSLog(@"4 fours: %@\n\n", found);
    NSLog(@"Missing: %@\n\n", missing);
    
    if ([missing count] == 6) {
      NSLog(@"Success!");
    }

}

@end

int main (int argc, const char * argv[])
{
  @autoreleasepool {
    Solution *solution = [[Solution alloc] init];
    [solution calculateFours];
    [solution printFours];
  }
}

