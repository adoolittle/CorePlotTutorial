//
//  YALStackedBarChartView.h
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <CorePlot/CorePlot-CocoaTouch.h>

typedef struct {
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
} YAPaddingInset;

@class YALStackedBarChartView;

//protocol for out public datasource
@protocol YALStackedBarChartViewDataSource <NSObject>

- (NSInteger)numberOfSectionInStackedBarChartView:(YALStackedBarChartView *)stackedBarChartView;
- (NSInteger)stackedBarChartView:(YALStackedBarChartView *)stackedBarChartView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)stackedBarChartView:(YALStackedBarChartView *)stackedBarChartView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIColor *)stackedBarChartView:(YALStackedBarChartView *)stackedBarChartView colorForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YALStackedBarChartView : CPTGraphHostingView

- (void)reloadData;

@property (nonatomic, weak) IBOutlet id <YALStackedBarChartViewDataSource> dataSource;

@property (nonatomic, assign) CGFloat sectionWidth;
@property (nonatomic, assign) CGFloat distanceBetweenBars;
@property (nonatomic, assign) CGFloat offsetFromLeft;
@property (nonatomic, assign) CGFloat offsetFromRight;
@property (nonatomic, assign) YAPaddingInset paddingInset;

@end
