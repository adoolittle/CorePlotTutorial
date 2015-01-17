//
//  YAExercise+YAPieChartProtocol.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 16.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALExercise+YALPieChartProtocol.h"

//model
#include "YALSet.h"

//category
#import "UIColor+YALColorFromHexString.h"

@implementation YALExercise (YALPieChartProtocol)

- (UIColor *)sectorColor {
    return [UIColor yal_colorFromHexString:self.colorHexName];
}

- (NSNumber *)sectorSize {
    return [self.sets valueForKeyPath:@"@sum.repCount"];
}

- (NSString *)sectorName {
    return self.name;
}

- (NSString *)sectorLegendString {
    double totalValue = 0;
    for (YALSet* set in [YALSet MR_findAll]) {
        totalValue += [[set valueForKeyPath:@"repCount"] floatValue];
    }
    double percentage = (100.f * [[self sectorSize] integerValue]) / totalValue;
    NSString *legendLabelString = [NSString stringWithFormat:@"%@ %ld (%.2f%%)", [self sectorName], (long)[[self sectorSize] integerValue], percentage];
    return legendLabelString;
}

@end
