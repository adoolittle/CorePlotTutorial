//
//  YALStackedBarChartView.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALStackedBarChartView.h"

static CGFloat const YALAxisXLabelTextFontSize = 12.0f;
static CGFloat const YALLineWidth = 1.0f;
static CGFloat const YALMultiplierForMimimalBarValue = 0.03f;
static CGFloat const YALDefaultPaddingTop = 10.0f;
static CGFloat const YALDefaultPaddingRight = 10.0f;
static CGFloat const YALDefaultPaddingBottom = 20.0f;
static CGFloat const YALDefaultPaddingLeft = 40.0f;
static CGFloat const YALDefaultSectionWidth = 20.0f;
static CGFloat const YALDefaultXAxeLeftOffset = 5.0f;
static CGFloat const YALDefaultXAxeRightOffset = 5.0f;
static CGFloat const YALDefaultDistanceBetweenBars = 10.0f;

@interface YALStackedBarChartView () <CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, assign) NSInteger *numberOfRecords;
@property (nonatomic, assign) CGFloat defaultMinimalHegiht;

@end

@implementation YALStackedBarChartView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private

- (void)commonInit {
    self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    [self setHostedGraph:self.graph];
    
    self.defaultMinimalHegiht = 0.05f;
    [self.graph setValue:@(0.f) forKey:@"paddingLeft"];
    [self.graph setValue:@(0.f) forKey:@"paddingTop"];
    [self.graph setValue:@(0.f) forKey:@"paddingRight"];
    [self.graph setValue:@(0.f) forKey:@"paddingBottom"];
    
    // setup
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor whiteColor];
    borderLineStyle.lineWidth = 2.0f;
    self.graph.plotAreaFrame.borderLineStyle = borderLineStyle;
    self.graph.plotAreaFrame.paddingTop = YALDefaultPaddingTop;
    self.graph.plotAreaFrame.paddingRight = YALDefaultPaddingRight;
    self.graph.plotAreaFrame.paddingBottom = YALDefaultPaddingBottom;
    self.graph.plotAreaFrame.paddingLeft = YALDefaultPaddingLeft;
    
    //set axes' line styles and interval ticks
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineWidth = YALLineWidth;
    
    //setup style for label for Y axis
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = YALAxisXLabelTextFontSize;
   
    
    //Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
    //setup format for x labels axes
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setGeneratesDecimalNumbers:TRUE];
    
    //X axis
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    x.axisLineStyle = gridLineStyle;
    
    //Y axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.majorGridLineStyle = gridLineStyle;
    y.minorTickLineStyle = gridLineStyle;
    y.majorTickLineStyle = gridLineStyle;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    y.labelTextStyle = textStyle;
    y.axisLineStyle = gridLineStyle;
    y.minorTicksPerInterval = 5;
    y.labelFormatter = formatter;
    
    _distanceBetweenBars = YALDefaultDistanceBetweenBars;
    _sectionWidth = YALDefaultSectionWidth;
    _offsetFromLeft = YALDefaultXAxeLeftOffset;
    _offsetFromRight = YALDefaultXAxeRightOffset;
}

#pragma mark - Public

- (void)reloadData {
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    
    // Remove previous plots
    [[self.graph allPlots] enumerateObjectsUsingBlock:^(CPTPlot *plot, NSUInteger idx, BOOL *stop) {
        [self.graph removePlot:plot];
    }];
    
    // Add new plots
    NSInteger numberOfSection = [self.dataSource numberOfSectionInStackedBarChartView:self];
    for (NSInteger section = 0; section < numberOfSection; section++) {
        NSInteger numberOfRows = [self.dataSource stackedBarChartView:self numberOfRowsInSection:section];
        for (NSInteger row = 0; row < numberOfRows; row++) {
            // Create plot
            CPTBarPlot *plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor yellowColor] horizontalBars:NO];
            
            // Setup plot
            CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
            borderLineStyle.lineColor = [CPTColor whiteColor];
            borderLineStyle.lineWidth = [@0.5 floatValue];
            plot.lineStyle = borderLineStyle;
            plot.barWidth = [[NSDecimalNumber numberWithFloat:_sectionWidth] decimalValue];
            plot.dataSource = self;
            
            //if current plot is first in section - barBasesVary = NO
            //If NO, a constant base value is used for all bars. If YES, the data source is queried to supply a base value for each bar.
            //The coordinate value of the fixed end of the bars.
            plot.barBasesVary = index == 0 ? NO : YES;
            plot.barCornerRadius = [@0 floatValue];
            
            //provide our plot with identifier - for this we made all staff with sections and objects
            //we can work with each plot as with row in table view, but placed into section.
            plot.identifier = [NSIndexPath indexPathForRow:row inSection:section];
            [self.graph addPlot:plot toPlotSpace:plotSpace];
        }
    }
    
    // Calculate XY ranges
    
    //calculating real data - real height
    CGFloat maxHeight = 0.f;
    for (NSInteger section = 0; section < numberOfSection; section++) {
        NSInteger numberOfRows = [self.dataSource stackedBarChartView:self numberOfRowsInSection:section];
        CGFloat sectionHeight = 0.f;
        for (NSInteger row = 0; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            sectionHeight += [self.dataSource stackedBarChartView:self heightForRowAtIndexPath:indexPath];
        }
        maxHeight = fmaxf(maxHeight, sectionHeight);
    }
    
    self.defaultMinimalHegiht = maxHeight * YALMultiplierForMimimalBarValue;
    
    // TODO: Refactor dual loops
    maxHeight = 0.f;
    
    for (NSInteger section = 0; section < numberOfSection; section++) {
        NSInteger numberOfRows = [self.dataSource stackedBarChartView:self numberOfRowsInSection:section];
        CGFloat sectionHeight = 0.f;
        for (NSInteger row = 0; row < numberOfRows; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            //
            sectionHeight += [self heightForRowAtIndexPath:indexPath];
        }
        maxHeight = fmaxf(maxHeight, sectionHeight);
    }
        
    //calculatedXAxisWidth
    CGFloat xAxisWidth = 0.f;
    xAxisWidth +=_offsetFromLeft + _sectionWidth * numberOfSection + _distanceBetweenBars * (numberOfSection - 1) + _offsetFromRight;
    
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:[@0 decimalValue] length:[@(maxHeight+15.f) decimalValue]];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:[@0 decimalValue] length:[@(xAxisWidth) decimalValue]];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    if (maxHeight == 0) {
        axisSet.yAxis.majorGridLineStyle = nil;
    }
    
    [self.graph reloadData];
}

#pragma mark - CPTPlotDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 1;
}

- (NSNumber *)numberForPlot:(CPTBarPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)recordIndex {
    NSIndexPath *indexPath = (NSIndexPath *)plot.identifier;
    
    // X Value
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return @(((indexPath.section) * (self.sectionWidth+self.distanceBetweenBars) + (self.sectionWidth/2)) + self.offsetFromLeft);
        
        // Y Value
    } else if (fieldEnum == CPTBarPlotFieldBarTip)  {
        CGFloat offset = 0;
        for (NSInteger row = 0; row < indexPath.row; row++) {
            offset += [self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
        }
        return @([self heightForRowAtIndexPath:indexPath] + offset);
        
        // Offset
    } else if (fieldEnum == CPTBarPlotFieldBarBase) {
        CGFloat offset = 0;
        for (NSInteger row = 0; row < indexPath.row; row++) {
            offset += [self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
        }
        
        return @(offset);
    } else {
        return nil;
    }
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self.dataSource stackedBarChartView:self heightForRowAtIndexPath:indexPath];
    
    if (height > self.defaultMinimalHegiht) {
        return height;
    } else {
        return self.defaultMinimalHegiht;
    }
    
    return height;
}

#pragma mark - CPTBarPlotDataSource

- (CPTFill *)barFillForBarPlot:(CPTBarPlot *)plot recordIndex:(NSUInteger)index {
    NSIndexPath *indexPath = (NSIndexPath *)plot.identifier;
    
    UIColor *color = [self.dataSource stackedBarChartView:self colorForRowAtIndexPath:indexPath];
    return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[color CGColor]]];
}

#pragma mark - Properties

- (void)setDataSource:(id<YALStackedBarChartViewDataSource>)dataSource {
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;
        
        [self reloadData];
    }
}

- (void)setSectionWidth:(CGFloat)sectionWidth {
    if (!(_sectionWidth == sectionWidth)) {
        _sectionWidth = sectionWidth;
        
        [self reloadData];
    }
}

- (void)setDistanceBetweenBars:(CGFloat)distanceBetweenBars {
    if (!(_distanceBetweenBars == distanceBetweenBars)) {
        _distanceBetweenBars = distanceBetweenBars;
        
        [self reloadData];
    }
}


- (void)setOffsetFromLeft:(CGFloat)offsetFromLeft {
    if (!(_offsetFromLeft == offsetFromLeft)) {
        _offsetFromLeft = offsetFromLeft;
        
        [self reloadData];
    }
}

- (void)setOffsetFromRight:(CGFloat)offsetFromRight {
    if (!(_offsetFromRight == offsetFromRight)) {
        _offsetFromRight = offsetFromRight;
        
        [self reloadData];
    }
}

- (void)setPaddingInset:(YAPaddingInset)paddingInset {
    if ((_paddingInset.top != paddingInset.top) ||
        (_paddingInset.right != paddingInset.right) ||
        (_paddingInset.bottom != paddingInset.bottom) ||
        (_paddingInset.left != paddingInset.left)
        )  {
        
        _paddingInset = paddingInset;
        
        [self reloadData];
    }
}

@end
