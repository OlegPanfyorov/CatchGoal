//
//  GoalOperations.h
//  catchGoal
//
//  Created by Roman Bogomolov on 22/02/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Goal;

@interface GoalOperations : NSManagedObject

@property (nonatomic, retain) NSDate * addDate;
@property (nonatomic, retain) NSNumber * addSum;
@property (nonatomic, retain) Goal *goal;

@end
