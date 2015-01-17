//
//  YAPieChartViewDataSource.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 25.12.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALPieChartViewDataSource.h"

//view
#import "YALPieChartView.h"

//model
#import "YALExercise.h"

@interface YALPieChartViewDataSource () <YAPieChartViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YALPieChartViewDataSource

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

#pragma mark - YAPieChartViewDataSource

- (NSInteger)numberOfSectorsInPieChartView:(YALPieChartView *)pieChartView{
    return  [self.fetchedResultsController.fetchedObjects count];
}

- (id <YALPieChartProtocol>)pieChartView:(YALPieChartView *)pieChartView sectorAtIndex:(NSInteger)index {
    return [self.fetchedResultsController.fetchedObjects objectAtIndex:index];
}


@end
