//
//  YALPieChartView.h
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 16.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <CorePlot/CorePlot-CocoaTouch.h>
#import "YALPieChartProtocol.h"
@class YALPieChartView;


//protocol for our public datasource
@protocol YAPieChartViewDataSource <NSObject>

- (NSInteger)numberOfSectorsInPieChartView:(YALPieChartView *)pieChartView;
- (id <YALPieChartProtocol>)pieChartView:(YALPieChartView *)pieChartView sectorAtIndex:(NSInteger)index;

@end

@interface YALPieChartView: CPTGraphHostingView

@property (nonatomic, weak) IBOutlet id <YAPieChartViewDataSource> dataSource;

- (void)reloadData;

@property (nonatomic, assign) CGFloat pieInnerCornerRadius;
@property (nonatomic, assign) CGFloat pieRadius;
@property (nonatomic, assign) CGFloat borderLineWidth;

@end
