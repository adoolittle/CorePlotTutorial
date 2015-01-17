//
//  NSDate+YALBeginningAndEndOfTheDay.h
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 17.01.15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YALBeginningAndEndOfTheDay)

+ (NSDate *)yal_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
- (NSDate *)yal_beginningOfDay;
- (NSDate *)yal_endOfDay;
- (NSDate *)yal_dateWithDaysAgo:(NSUInteger)days;

@end
