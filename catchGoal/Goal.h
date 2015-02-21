//
//  Goal.h
//  catchGoal
//
//  Created by Roman Bogomolov on 22/02/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GoalOperations;

@interface Goal : NSManagedObject

@property (nonatomic, retain) NSDate * finalDate;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * perMonth;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * progress;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * complited;
@property (nonatomic, retain) NSSet *operations;
@end

@interface Goal (CoreDataGeneratedAccessors)

- (void)addOperationsObject:(GoalOperations *)value;
- (void)removeOperationsObject:(GoalOperations *)value;
- (void)addOperations:(NSSet *)values;
- (void)removeOperations:(NSSet *)values;

@end
