//
//  YALPieChartProtocol.h
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 16.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YALPieChartProtocol <NSObject>

@required

- (UIColor *)sectorColor;
- (NSNumber *)sectorSize;
- (NSString *)sectorName;
- (NSString *)sectorLegendString;

@end
