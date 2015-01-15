//
//  YALSet.h
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 15.01.15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class YALExercise;

@interface YALSet : NSManagedObject

@property (nonatomic, retain) NSDate * doneAt;
@property (nonatomic, retain) NSNumber * repCount;
@property (nonatomic, retain) YALExercise *exercise;

@end
