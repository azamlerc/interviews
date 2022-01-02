#import <Foundation/Foundation.h>
#import <stdio.h>

@interface Calendar: NSObject

- (NSArray *) makeMonth: (int) month inYear: (int) year;

@end

@implementation Calendar

- (NSArray *) makeMonth: (int) month inYear: (int) year {
  NSDateComponents *monthComps = [[NSDateComponents alloc] init];
  NSDateComponents *lastComps = [[NSDateComponents alloc] init];
  NSDateComponents *yesterdayComps = [[NSDateComponents alloc] init];
  NSDateComponents *tomorrowComps = [[NSDateComponents alloc] init];

  monthComps.year = year;
  monthComps.month = month;
  lastComps.month = 1;
  lastComps.day = -1;
  yesterdayComps.day = -1;
  tomorrowComps.day = 1;
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSMutableArray *weeks = [NSMutableArray array];
  NSDate *date = [calendar dateFromComponents:monthComps];
  NSDate *last = [calendar dateByAddingComponents:lastComps toDate:date options:0];
  
  while ([calendar components:NSCalendarUnitWeekday fromDate: date].weekday > 1) {
    date = [calendar dateByAddingComponents:yesterdayComps toDate:date options:0];
  }
  
  while ([date compare: last] == NSOrderedAscending) {
    NSMutableArray *week = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
      NSInteger day = [calendar components:NSCalendarUnitDay fromDate:date].day;
      [week addObject: [NSNumber numberWithInt: day]];
      date = [calendar dateByAddingComponents:tomorrowComps toDate:date options:0];
    }
    [weeks addObject: week];
  }
  
  return weeks;
}

@end

int main (int argc, const char * argv[])
{
  @autoreleasepool {
    Calendar *calendar = [[Calendar alloc] init];
    NSArray *weeks = [calendar makeMonth:12 inYear:2021];
    
    for (NSArray *week in weeks) {
      NSLog(@"%@", week);
    }

    if ([[calendar makeMonth:2 inYear:2015] count] == 4) {
      NSLog(@"Feb 2015 has 4 weeks");
    }
    if ([[calendar makeMonth:4 inYear:2021] count] == 5) {
      NSLog(@"Apr 2021 has 5 weeks");
    }
    if ([[calendar makeMonth:5 inYear:2021] count] == 6) {
      NSLog(@"May 2015 has 6 weeks");
    }
  }
}