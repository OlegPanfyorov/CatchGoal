//
//  DetailViewController.h
//  catchGoal
//
//  Created by GeX on 15/03/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (assign, nonatomic) NSInteger selectedItemInArray;
@property (strong, nonatomic) GoalOperations* operations;
@property (nonatomic, strong) Goal *goal;
@end
