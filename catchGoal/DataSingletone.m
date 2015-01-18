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
        self.goalsArray = [NSMutableArray new];
    }
    return self;
}

@end
