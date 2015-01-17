//
//  YALStackedBarChartObject.h
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YALExercise;

@interface YALStackedBarChartObject : NSObject

//each stackedBarChartObject represents sets for specific exercise per day
//More that one set can be done per day

- (instancetype)initWithDate:(NSDate *)date exercise:(YALExercise *)exercise;

//we collect all exercises for some date (section) 
+ (NSArray *)arrayWithDate:(NSDate *)date exercises:(NSArray *)exercises;

//any stackedBarChartObject can return its color and height

//calculate height for each stackedBarChartObject
//total height equals to sum of all reps for exercise done on specific date
- (CGFloat)height;
- (UIColor *)color;

@end
