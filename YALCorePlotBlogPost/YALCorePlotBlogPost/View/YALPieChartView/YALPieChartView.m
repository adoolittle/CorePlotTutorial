//
//  YALPieChartView.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 16.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALPieChartView.h"

static CGFloat const YALAreaPaddingTop = 0.0f;
static CGFloat const YALAreaPaddingRight = 0.0f;
static CGFloat const YALAreaPaddingLeft = 0.0f;
static CGFloat const YALAreaPaddingBottom = 0.0f;
static CGFloat const YALPieInnerRadius = 0.0f;
static CGFloat const YALPieRadius = 70.0f;
static CGFloat const YALPieBorderWidth = 1.0f;
static CGFloat const YALStartDrawingPoint = M_PI/2.f;
static CGFloat const YALMinimalDegreesToDisplay = 3.f;

@interface YALPieChartView () <CPTPieChartDataSource, CPTPieChartDelegate>

@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, assign) CGFloat degreeAmount;
@property (nonatomic, assign) CGFloat totalAmount;

@end

@implementation YALPieChartView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Private

- (void)setup {
    //Create graph and set it as host view's graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.bounds];
    
    CGRect sizeForGraph = self.bounds;
    self.graph.bounds = sizeForGraph;
    [self setHostedGraph:self.graph];
    
    //set border for graph view
    [self.graph setValue:@(0.f) forKey:@"paddingLeft"];
    [self.graph setValue:@(0.f) forKey:@"paddingTop"];
    [self.graph setValue:@(0.f) forKey:@"paddingRight"];
    [self.graph setValue:@(0.f) forKey:@"paddingBottom"];
    
    
    //set graph padding and theme
    self.graph.plotAreaFrame.paddingTop = YALAreaPaddingTop;
    self.graph.plotAreaFrame.paddingRight = YALAreaPaddingRight;
    self.graph.plotAreaFrame.paddingBottom = YALAreaPaddingBottom;
    self.graph.plotAreaFrame.paddingLeft = YALAreaPaddingLeft;
    self.graph.plotAreaFrame.plotArea.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.graph.axisSet;
    axisSet.hidden = YES;
    
    CPTAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    CPTXYAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    //disable axis for pie chart
    self.graph.axisSet = nil;
    
    _pieInnerCornerRadius = YALPieInnerRadius;
    _pieRadius = YALPieRadius;
    _borderLineWidth = YALPieBorderWidth;
}

#pragma mark - Public

- (void)reloadData {
    
    //calculating total amout of data which we need to display on chart
    self.totalAmount = 0.f;
    NSUInteger numberOfCharts = [_dataSource numberOfSectorsInPieChartView:self];
    for (int i = 0; i < numberOfCharts; i ++) {
        self.totalAmount += [[[_dataSource pieChartView:self sectorAtIndex:i] sectorSize] integerValue];
    }
    
    // Remove previous plots
    [[self.graph allPlots] enumerateObjectsUsingBlock:^(CPTPlot *plot, NSUInteger idx, BOOL *stop) {
        [self.graph removePlot:plot];
    }];
    
        // Add pie chart
        CPTPieChart *piePlot = [[CPTPieChart alloc] init];
        piePlot.dataSource = self;
        piePlot.delegate = self;
        piePlot.pieRadius = _pieRadius;
        piePlot.pieInnerRadius = _pieInnerCornerRadius;
        piePlot.identifier      = @"Pie Chart 1";
        piePlot.startAngle      = YALStartDrawingPoint;
        piePlot.sliceDirection  = CPTPieDirectionCounterClockwise;
        CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
        lineStyle.lineColor = [CPTColor whiteColor];
        lineStyle.lineWidth = _borderLineWidth;
        piePlot.borderLineStyle = lineStyle;
    
        [self.graph addPlot:piePlot];

    //Add legend to graph
    CPTLegend *theLegend = [CPTLegend legendWithGraph:self.graph];
    theLegend.numberOfColumns = 2;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    self.graph.legend = theLegend;
    
    //calculating amount of data for 1 degree and muliplie it by number of minimal degrees to display
    self.degreeAmount= (self.totalAmount / 360.f) * YALMinimalDegreesToDisplay;
    
    NSLog(@"totalAmount:%f",self.totalAmount);
    [self.graph reloadData];
}

//implementing methods of Core Plot dataSource and delegate
#pragma mark - CPTPieChartDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
   return [self.dataSource numberOfSectorsInPieChartView:self];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    id <YALPieChartProtocol> pieProtocol = [self.dataSource pieChartView:self sectorAtIndex:index];
    if ([[pieProtocol sectorSize] integerValue] < self.degreeAmount) {
        return @(self.degreeAmount);
    }
    return [pieProtocol sectorSize];
}

#pragma mark - CPTPieChartDelegate

- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    id <YALPieChartProtocol> pieProtocol = [self.dataSource pieChartView:self sectorAtIndex:index];
    return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[pieProtocol sectorColor] CGColor]]];
}

- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx {
    id <YALPieChartProtocol> pieProtocol = [self.dataSource  pieChartView:self sectorAtIndex:idx];
    return [pieProtocol sectorName];
}

#pragma mark - Properties

- (void)setDataSource:(id<YAPieChartViewDataSource>)dataSource {
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;
        
        [self reloadData];
    }
}

- (void)setPieInnerCornerRadius:(CGFloat)pieInnerCornerRadius {
    if (!(_pieInnerCornerRadius == pieInnerCornerRadius)) {
        _pieInnerCornerRadius = pieInnerCornerRadius;
        
        [self reloadData];
    }
}

- (void)setPieRadius:(CGFloat)pieRadius {
    if (!(_pieRadius == pieRadius)) {
        _pieRadius = pieRadius;
        
        [self reloadData];
    }
}

- (void)setBorderLineWidth:(CGFloat)borderLineWidth {
    if (!(_borderLineWidth == borderLineWidth)) {
        _borderLineWidth = borderLineWidth;
        
        [self reloadData];
    }
}

@end