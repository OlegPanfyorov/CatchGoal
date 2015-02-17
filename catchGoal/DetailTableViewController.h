//
//  DetailTableViewController.h
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoalOperations;
@class Goal;

@interface DetailTableViewController : UITableViewController

@property (assign, nonatomic) NSInteger selectedItemInArray;
@property (strong, nonatomic) GoalOperations* operations;
@property (nonatomic, strong) Goal *goal;

@end
