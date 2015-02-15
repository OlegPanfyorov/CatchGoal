//
//  detailNameCell.h
//  catchGoal
//
//  Created by Roman Bogomolov on 15/02/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goalInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *goalName;
@property (weak, nonatomic) IBOutlet UILabel *totalSum;
@property (weak, nonatomic) IBOutlet KAProgressLabel *circleProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressMoney;

@end