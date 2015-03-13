//
//  GoalTableViewCell.m
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "GoalTableViewCell.h"

@implementation GoalTableViewCell



- (void)awakeFromNib {
    self.containerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.17];
    self.backgroundColor = [UIColor clearColor];
    self.lineProgressView.progressType = ProgressLabelRect;
    self.lineProgressView.backBorderWidth = 0.0;
    self.lineProgressView.frontBorderWidth = 0.0;
    self.lineProgressView.layer.cornerRadius = self.lineProgressView.frame.size.height / 2;
    self.lineProgressView.clipsToBounds = YES;
    self.image.backgroundColor = [UIColor clearColor];
    self.image.layer.cornerRadius = self.image.frame.size.height / 2;
    self.image.clipsToBounds = YES;    
}
@end