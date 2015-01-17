//
//  YALBartChartView.h
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 13.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <CorePlot/CorePlot-CocoaTouch.h>

#import "YALBarChartProtocol.h"

typedef struct {
    CGFloat top;
    CGFloat right;
    CGFloat bottom;
    CGFloat left;
} YAPaddingInset;

@class YALBarChartView;

//protocol for our public datasource
@protocol YABarChartViewDataSource <NSObject>

- (NSInteger)numberOfBarsInBarChartView:(YALBarChartView *)barChartView;
- (id <YALBarChartProtocol>)barChartView:(YALBarChartView *)barChartView barAtIndex:(NSInteger)index;

@end

@interface YALBarChartView : CPTGraphHostingView

//our public dataSource
@property (nonatomic, weak) IBOutlet id <YABarChartViewDataSource> dataSource;

- (void)reloadData;
@property (nonatomic, assign) CGFloat barWidth;
@property (nonatomic, assign) CGFloat distanceBetweenBars;
@property (nonatomic, assign) CGFloat offsetFromLeft;
@property (nonatomic, assign) CGFloat offsetFromRight;
@property (nonatomic, assign) YAPaddingInset paddingInset;

@end

