//
//  YALBarChartViewDataSource.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 25.12.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALBarChartViewDataSource.h"

//view
#import "YALBarChartView.h"

//model
#import "YALExercise.h"

@interface YALBarChartViewDataSource () <YABarChartViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YALBarChartViewDataSource

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _fetchedResultsController = [YALExercise MR_fetchAllSortedBy:@"name"
                                                          ascending:NO
                                                      withPredicate:nil
                                                            groupBy:nil
                                                           delegate:nil
                                                          inContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return self;
}

#pragma mark - YABarChartViewDataSource

- (NSInteger)numberOfBarsInBarChartView:(YALBarChartView *)barChartView {
    return  [self.fetchedResultsController.fetchedObjects count];
}

- (id <YALBarChartProtocol>)barChartView:(YALBarChartView *)barChartView barAtIndex:(NSInteger)index {
    return [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
}

@end
