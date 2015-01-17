//
//  YALStackedBarChartObject.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALStackedBarChartObject.h"

//model
#import "YALExercise.h"
#import "YALSet.h"

//category
#import "NSDate+YALBeginningAndEndOfTheDay.h"
#import "UIColor+YALColorFromHexString.h"

@interface YALStackedBarChartObject ()

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) YALExercise *exercise;

@end

@implementation YALStackedBarChartObject

#pragma mark - Initialization

- (instancetype)initWithDate:(NSDate *)date exercise:(YALExercise *)exercise {
    self = [super init];
    if (self) {
        _date = date;
        _exercise = exercise;
    }
    NSLog(@"called");
    return self;
}

+ (NSArray *)arrayWithDate:(NSDate *)date exercises:(NSArray *)exercises {
    NSMutableArray *array = [NSMutableArray array];
    for (YALExercise *exercise in exercises) {
        YALStackedBarChartObject *object = [[self alloc] initWithDate:date exercise:exercise];
        [array addObject:object];
    }
    return [array copy];
}

#pragma mark - Public

//calculated height for each stackedBarChartObject
//total height equals to sum of all reps for exercise done on specific date
- (CGFloat)height {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"doneAt >= %@ AND doneAt < %@", [self.date yal_beginningOfDay], [self.date yal_endOfDay]];
    NSSet *exerciseSets = [self.exercise.sets filteredSetUsingPredicate:predicate];
    NSNumber *setsRepTotalCount = [exerciseSets valueForKeyPath:@"@sum.repCount"];
    return [setsRepTotalCount floatValue];
}

//each stackedBarChartObject can return its color
- (UIColor *)color {
    return [UIColor yal_colorFromHexString:self.exercise.colorHexName];
}

@end
