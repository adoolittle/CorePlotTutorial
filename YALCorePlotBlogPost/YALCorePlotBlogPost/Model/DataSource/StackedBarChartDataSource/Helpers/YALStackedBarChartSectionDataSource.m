//
//  YAStackedBarChartSectionDataSource.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALStackedBarChartSectionDataSource.h"

//model
#import "YALStackedBarChartObject.h"
#import "YALStackedBarChartSection.h"

//category
#import "NSDate+YALBeginningAndEndOfTheDay.h"

static NSUInteger const kTestYear = 2014;
static NSUInteger const kTestMonth = 10;
static NSUInteger const kTestDay = 14;

@interface YALStackedBarChartSectionDataSource ()

@property (nonatomic, strong) NSArray *sections;

@end

@implementation YALStackedBarChartSectionDataSource

#pragma mark - Initialization

- (instancetype)initWithDates:(NSArray *)dates inContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        NSMutableArray *mutableSectionArray = [NSMutableArray array];
        for (NSDate *date in dates) {
            YALStackedBarChartSection *section = [[YALStackedBarChartSection alloc] initWithDate:date inContext:context];
            [mutableSectionArray addObject:section];
        }
        
        _sections = [mutableSectionArray copy];
    }
    return self;
}

+ (instancetype)dataSourceForLast7DaysInContext:(NSManagedObjectContext *)context {
    // TODO: Please, refactor this method!
    NSMutableArray *dates = [NSMutableArray array];
    NSDate *today = [NSDate yal_dateWithYear:kTestYear month:kTestMonth day:kTestDay];
    
    [dates addObject:[today yal_dateWithDaysAgo:6]];
    [dates addObject:[today yal_dateWithDaysAgo:5]];
    [dates addObject:[today yal_dateWithDaysAgo:4]];
    [dates addObject:[today yal_dateWithDaysAgo:3]];
    [dates addObject:[today yal_dateWithDaysAgo:2]];
    [dates addObject:[today yal_dateWithDaysAgo:1]];
    [dates addObject:today];
    
    return [[self alloc] initWithDates:[dates copy] inContext:context];
}

#pragma mark - Public

- (NSInteger)numberOfSection {
    return [self.sections count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    YALStackedBarChartSection *sectionObject = self.sections[section];
    return [sectionObject numberOfObjects];
}

- (YALStackedBarChartObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    YALStackedBarChartSection *sectionObject = self.sections[indexPath.section];
    return [sectionObject objectAtIndex:indexPath.row];
}

@end
