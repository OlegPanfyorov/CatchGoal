//
//  GoalTableViewCell.h
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealTableViewCell.h"

@interface GoalTableViewCell : SWRevealTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet KAProgressLabel *lineProgressView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
