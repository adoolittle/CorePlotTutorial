//
//  YALAppDelegate.m
//  YALCorePlotBlogPost
//
//  Created by Eugene Goloboyar on 15.01.15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "YALAppDelegate.h"

//helpers
#import "YALDefaulltDatamporter.h"

@implementation YALAppDelegate

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [MagicalRecord setupCoreDataStack];
    }
    return self;
}

#pragma mark - Private

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [YALDefaulltDatamporter imortDefaultData];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}
							
@end
