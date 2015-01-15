//
//  YALExercise.h
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 15.01.15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YALExercise : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * colorHexName;
@property (nonatomic, retain) NSSet *sets;
@end

@interface YALExercise (CoreDataGeneratedAccessors)

- (void)addSetsObject:(NSManagedObject *)value;
- (void)removeSetsObject:(NSManagedObject *)value;
- (void)addSets:(NSSet *)values;
- (void)removeSets:(NSSet *)values;

@end
