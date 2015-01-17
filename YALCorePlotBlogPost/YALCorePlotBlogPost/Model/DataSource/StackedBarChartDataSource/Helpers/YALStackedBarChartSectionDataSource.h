//
//  YAStackedBarChartSectionDataSource.h
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 17.10.14.
//  Copyright (c) 2014 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YALStackedBarChartObject;

@interface YALStackedBarChartSectionDataSource : NSObject

+ (instancetype)dataSourceForLast7DaysInContext:(NSManagedObjectContext *)context;

- (NSInteger)numberOfSection;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (YALStackedBarChartObject *)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
