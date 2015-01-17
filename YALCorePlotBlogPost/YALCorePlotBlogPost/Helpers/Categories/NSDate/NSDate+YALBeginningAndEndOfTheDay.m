//
//  NSDate+YALBeginningAndEndOfTheDay.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 17.01.15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "NSDate+YALBeginningAndEndOfTheDay.h"

@implementation NSDate (YALBeginningAndEndOfTheDay)

+ (NSDate *)yal_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

// https://github.com/mattt/CupertinoYankee
// Thank you, Mattt!
- (NSDate *)yal_beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                               fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)yal_endOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    
    return [[calendar dateByAddingComponents:components toDate:[self yal_beginningOfDay] options:0]
            dateByAddingTimeInterval:-1];
}

- (NSDate *)yal_dateWithDaysAgo:(NSUInteger)days {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-days];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

@end
