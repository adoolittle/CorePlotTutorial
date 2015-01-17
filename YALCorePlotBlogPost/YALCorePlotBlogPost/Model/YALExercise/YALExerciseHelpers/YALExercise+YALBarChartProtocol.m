//
//  YAExercise+YABarChartProtocol.m
//  YALCorePlotBlogPost

//  Created by Eugene Goloboyar on 13.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import "YALExercise+YALBarChartProtocol.h"

//model
#import "YALSet.h"

//category
#import "UIColor+YALColorFromHexString.h"

@implementation YALExercise (YALBarChartProtocol)

- (UIColor *)barColor {
    return [UIColor yal_colorFromHexString:self.colorHexName];
}

- (NSNumber *)barValue {
    return [self.sets valueForKeyPath:@"@sum.repCount"];
}

- (NSString *)barName {
    return self.name;
}

- (NSString *)barLegendString {
    double totalValue = 0;
    for (YALSet* set in [YALSet MR_findAll]) {
        totalValue += [[set valueForKeyPath:@"repCount"] floatValue];
    }
    double percentage = (100.f * [[self barValue] integerValue]) / totalValue;
    NSString *legendLabelString = [NSString stringWithFormat:@"%@ %ld (%.2f%%)", [self barName], (long)[[self barValue] integerValue], percentage];
    
    return legendLabelString;
}

@end
