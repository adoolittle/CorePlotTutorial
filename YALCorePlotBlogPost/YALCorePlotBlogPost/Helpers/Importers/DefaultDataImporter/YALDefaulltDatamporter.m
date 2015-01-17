//
//  YALDefaulltDatamporter.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 17.01.15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "YALDefaulltDatamporter.h"

//model
#import "YALExercise.h"

static NSString *const YALFirstRunKey = @"kYALFirstRunKey";

@implementation YALDefaulltDatamporter

+ (void)imortDefaultData {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:YALFirstRunKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:YALFirstRunKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YALExercises" ofType:@"plist"]];
        NSManagedObjectContext *ctx = [NSManagedObjectContext MR_contextForCurrentThread];
        [YALExercise MR_importFromArray:array inContext:ctx];
        [ctx MR_saveToPersistentStoreAndWait];
    }
}

@end
