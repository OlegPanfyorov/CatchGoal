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
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
        self.goalsArray = [NSMutableArray array];
    }
    return self;
}

- (void) saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


@end
