//
//  YALStackedBarChartDataSource.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 25.12.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALStackedBarChartDataSource.h"

//view
#import "YALStackedBarChartView.h"

//model
#import "YALStackedBarChartSectionDataSource.h"
#import "YALStackedBarChartObject.h"

@interface YALStackedBarChartDataSource () <YALStackedBarChartViewDataSource>

@property (nonatomic, strong) YALStackedBarChartSectionDataSource *sectionDataSource;

@end

@implementation YALStackedBarChartDataSource

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _sectionDataSource = [YALStackedBarChartSectionDataSource
                              dataSourceForLast7DaysInContext:[NSManagedObjectContext MR_defaultContext]];
    }
    return self;
}

#pragma mark - YAStackedBarChartViewDataSource

- (NSInteger)numberOfSectionInStackedBarChartView:(YALStackedBarChartView *)stackedBarChartView {
    return [self.sectionDataSource numberOfSection];
}

- (NSInteger)stackedBarChartView:(YALStackedBarChartView *)stackedBarChartView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionDataSource numberOfRowsInSection:section];
}

- (CGFloat)stackedBarChartView:(YALStackedBarChartView *)stackedBarChartView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YALStackedBarChartObject *object = [self.sectionDataSource objectAtIndexPath:indexPath];
    return [object height];
}

- (UIColor *)stackedBarChartView:(YALStackedBarChartView *)stackedBarChartView colorForRowAtIndexPath:(NSIndexPath *)indexPath {
    YALStackedBarChartObject *object = [self.sectionDataSource objectAtIndexPath:indexPath];
    return [object color];
}

@end
