//
//  Goal.h
//  catchGoal
//
//  Created by Roman Bogomolov on 16/02/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GoalOperations;

@interface Goal : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * finalDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * progress;
@property (nonatomic, retain) NSNumber * perMonth;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) GoalOperations *opetations;

@end
