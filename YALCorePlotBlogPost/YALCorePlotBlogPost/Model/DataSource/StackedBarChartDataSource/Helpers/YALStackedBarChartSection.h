//
//  YALStackedBarChartSection.h
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YALStackedBarChartObject;

@interface YALStackedBarChartSection : NSObject

//init each section 
- (instancetype)initWithDate:(NSDate *)date inContext:(NSManagedObjectContext *)context;

- (NSUInteger)numberOfObjects;

- (YALStackedBarChartObject *)objectAtIndex:(NSInteger)index;

@end
