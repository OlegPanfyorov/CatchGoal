//
//  DataSingletone.m
//  catchGoal
//
//  Created by Oleg Panforov on 1/18/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "DataSingletone.h"

@implementation DataSingletone

+ (DataSingletone *)sharedModel {
    
    static DataSingletone *sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}



- (id)init {
    if (self = [super init]) {
        
        self.goalsArray = [NSMutableArray array];

    }
    return self;
}

- (void)save {
    
    [[NSUserDefaults standardUserDefaults] rm_setCustomObject:self.goalsArray forKey:@"goalsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)load {
    
    if ([[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"goalsArray"]) {
        self.goalsArray = [[NSUserDefaults standardUserDefaults] rm_customObjectForKey:@"goalsArray"];

    }
    
}

- (void)deleteAllGoals {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"goalsArray"];
    self.goalsArray = nil;

}
@end
