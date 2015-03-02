//
//  detailNameCell.h
//  catchGoal
//
//  Created by Roman Bogomolov on 15/02/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class goalInfoCell;

@protocol GoalInfoCellDelegate <NSObject>
@required
- (void)showPhoto;
@end

@interface goalInfoCell : UITableViewCell

@property (nonatomic, assign) id<GoalInfoCellDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *goalImageButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet KAProgressLabel *circleProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextGoalButton;
@property (weak, nonatomic) IBOutlet UIButton *previousGoalButton;

@end
