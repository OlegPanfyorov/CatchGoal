//
//  detailNameCell.h
//  catchGoal
//
//  Created by Roman Bogomolov on 15/02/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface goalInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goalImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet KAProgressLabel *circleProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressMoney;
@property (weak, nonatomic) IBOutlet UIButton *nextGoalButton;
@property (weak, nonatomic) IBOutlet UIButton *previousGoalButton;

@end
