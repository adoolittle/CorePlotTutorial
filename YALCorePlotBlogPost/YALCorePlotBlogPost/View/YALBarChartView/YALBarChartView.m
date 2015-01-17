//
//  YALBartChartView.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 13.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALBarChartView.h"

CGFloat const YAAreaPaddingTop = 0.0f;
CGFloat const YAAreaPaddingRight = 10.0f;
CGFloat const YAAreaPaddingLeft = 80.0f;
CGFloat const YAAreaPaddingBottom = 120.0f;
CGFloat const YAAxisXLabelTextFontSize = 10.0f;
CGFloat const YAAxisXLabelOffset = 0.0f;
CGFloat const YABarOffset = 5.0f;
CGFloat const YABarWidth = 5.0f;
CGFloat const YALineWidth = 1.0f;
CGFloat const YAMajorTickLength = 5.0f;
CGFloat const YAMinorTickLength = 5.0f;
CGFloat const YADefaultTickInterval = 1.0f;
CGFloat const YABorderLineStyleWidth = .5f;
CGFloat const YAMultiplierForMimimalBarValue = 0.015f;
NSUInteger const YAMultiplierToAdjustAxisYSize = 10;

@interface YALBarChartView () <CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, assign) CGFloat defaultMinimalBarValue;

@end

@implementation YALBarChartView

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
    //Create graph and set it as host view's graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.bounds];
    [self setHostedGraph:self.graph];
    
    
    self.defaultMinimalBarValue = 0.05f;
    //remove default core plot border around graph
    [self.graph setValue:@(0.f) forKey:@"paddingLeft"];
    [self.graph setValue:@(0.f) forKey:@"paddingTop"];
    [self.graph setValue:@(0.f) forKey:@"paddingRight"];
    [self.graph setValue:@(0.f) forKey:@"paddingBottom"];
    
    //set graph padding and theme
    self.graph.plotAreaFrame.paddingTop = YAAreaPaddingTop;
    self.graph.plotAreaFrame.paddingRight = YAAreaPaddingRight;
    self.graph.plotAreaFrame.paddingBottom = YAAreaPaddingBottom;
    self.graph.plotAreaFrame.paddingLeft = YAAreaPaddingLeft;
    self.graph.plotAreaFrame.plotArea.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    //setup axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    //setup style for label for X axis
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = YAAxisXLabelTextFontSize;
    textStyle.color = [CPTColor colorWithCGColor:[UIColor blueColor].CGColor];
    
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    axisSet.xAxis.labelTextStyle = textStyle;
    axisSet.xAxis.labelOffset = YAAxisXLabelOffset;
    
    [axisSet.xAxis setLabelingPolicy:CPTAxisLabelingPolicyAutomatic];
    
    //set axes' line styles and interval ticks
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor colorWithCGColor:[UIColor grayColor].CGColor];
    lineStyle.lineWidth = YALineWidth;
    
    //setup format for x labels axes
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setGeneratesDecimalNumbers:TRUE];
    
    axisSet.xAxis.labelFormatter = formatter;
    
    // Y Axis
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.axisLineStyle = lineStyle;
    
    // X Major Tick
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(YADefaultTickInterval);
    axisSet.xAxis.majorTickLength = YAMajorTickLength;
    
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLength = YAMinorTickLength;
    
    axisSet.xAxis.majorGridLineStyle = lineStyle;
    
    _barWidth = YABarWidth;
    _distanceBetweenBars  = YABarOffset;
}


#pragma mark - Private

- (void)reloadData {
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    NSInteger numberOfPlots = [self.dataSource numberOfBarsInBarChartView:self];
    CPTBarPlot *plot = [[CPTBarPlot alloc] init];
    plot.dataSource = self;
    plot.delegate = self;
    [plot setBarsAreHorizontal:YES];
    plot.barWidth = [[NSDecimalNumber numberWithFloat:_barWidth] decimalValue];
    plot.barOffset = [[NSDecimalNumber numberWithFloat:_distanceBetweenBars] decimalValue];
    [plot setBarsAreHorizontal:YES];
    
    // Remove bar outlines
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor whiteColor];
    borderLineStyle.lineWidth = YABorderLineStyleWidth;
    plot.lineStyle = borderLineStyle;
    [self.graph addPlot:plot];
    
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Arial";
    textStyle.fontSize = YAAxisXLabelTextFontSize;
    NSMutableArray *labelsArray = [NSMutableArray array];
    
    //calculated maxWidth  for bar
    CGFloat maxValue = 0.f;
    for (int i = 0; i < numberOfPlots; i++) {
        id <YALBarChartProtocol> barProtocol = [self.dataSource barChartView:self barAtIndex:i];
        maxValue = fmaxf(maxValue, [[barProtocol barValue] integerValue]);
    }
        
    //recalculated plotSpace for X axe with maxWidth
    //recalculated plotSpace for Y axe with number of plots multipled by some constant
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.f)
                                                    length:CPTDecimalFromCGFloat(maxValue+1.f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.f)
                                                    length:CPTDecimalFromInteger((numberOfPlots)*YAMultiplierToAdjustAxisYSize)];
    
    for (int i = 0; i < numberOfPlots; i++) {
        id <YALBarChartProtocol> barProtocol = [self.dataSource barChartView:self barAtIndex:i];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[barProtocol barName] textStyle:textStyle];
        [label setTickLocation:CPTDecimalFromInt((i*YAMultiplierToAdjustAxisYSize)+5)];
        [labelsArray addObject:label];
    }
    
    //Add legend to graph
    CPTLegend *theLegend = [CPTLegend legendWithGraph:self.graph];
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    CGFloat legendPadding = -(self.bounds.size.width / 8);
    self.graph.legendDisplacement = CGPointMake(legendPadding + 55, 0.0);
    self.graph.legend = theLegend;

    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
    [axisSet.yAxis setLabelingPolicy: CPTAxisLabelingPolicyNone];
    [axisSet.yAxis setAxisLabels:[NSSet setWithArray:labelsArray]];
    
    
    //recalculated default minimalBarValue for to make all bars visible even if they depict small amouts of data
    self.defaultMinimalBarValue = ((maxValue) * YAMultiplierForMimimalBarValue);

    //recalculated interval for axis
    if (maxValue == 0) {
        axisSet.xAxis.majorGridLineStyle = nil;
    }
    
    NSLog(@"maxValue:%f",maxValue);
    
    //makes all Plot reload their data
    [self.graph reloadData];
}
//
#pragma mark - CPTPlotDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.dataSource numberOfBarsInBarChartView:self];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    id <YALBarChartProtocol> barProtocol = [self.dataSource barChartView:self barAtIndex:index];
    
    //for Y coordinate we return index of plot multupled by our constant
    if (fieldEnum == CPTBarPlotFieldBarLocation) {
        return @(index*YAMultiplierToAdjustAxisYSize);
        
    //for X coordninate we return value (width) of Plot or calculated default minimalValue
    } else if (fieldEnum == CPTBarPlotFieldBarTip) {
        if ([[barProtocol barValue] doubleValue] < self.defaultMinimalBarValue) {
            return @(self.defaultMinimalBarValue);
        }
        return [barProtocol barValue];
    } else {
        NSAssert(NO, @"Undefined fieldEnum: %ld", (unsigned long)fieldEnum);
        return nil;
    }
}

#pragma mark - CPTBarPlotDataSource

- (CPTFill *)barFillForBarPlot:(CPTBarPlot *)plot recordIndex:(NSUInteger)index {
    //any object which implemented methods of <YABarChartProtocol> can return color for plot
    id <YALBarChartProtocol> barProtocol = [self.dataSource barChartView:self barAtIndex:index];
    
    return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[barProtocol barColor] CGColor]]];
}

- (NSString *)legendTitleForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx {
    id <YALBarChartProtocol> barProtocol = [self.dataSource barChartView:self barAtIndex:idx];
    return [barProtocol barLegendString];
}

#pragma mark - Properties

- (void)setDataSource:(id<YABarChartViewDataSource>)dataSource {
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;
        
        //reload data after setting dataSource
        [self reloadData];
    }
}

- (void)setBarWidth:(CGFloat)sectionWidth {
    if (!(_barWidth == sectionWidth)) {
        _barWidth = sectionWidth;
        
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

