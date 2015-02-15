//
//  DataSingletone.h
//  catchGoal
//
//  Created by Oleg Panforov on 1/18/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "NSObject+RMArchivable.h"
@interface DataSingletone : NSObject

@property (strong, nonatomic) NSMutableArray* goalsArray;

+ (DataSingletone *)sharedModel;

-(id) init;

- (void)save;
- (void)load;
- (void)deleteAllGoals;


@end
