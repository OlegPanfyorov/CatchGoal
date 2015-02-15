//
//  DetailTableViewController.h
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DetailTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *perMonthLabel;

@property (weak, nonatomic) IBOutlet KAProgressLabel *circleProgressLabel;

@property (assign, nonatomic) NSInteger selectedItemInArray;


@end
