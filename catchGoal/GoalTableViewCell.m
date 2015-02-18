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
    self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    self.containerView.layer.cornerRadius = 5.f;
    self.containerView.layer.borderColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor;
    self.containerView.layer.borderWidth = 1.f;
    self.lineProgressView.progressType = ProgressLabelRect;
    self.lineProgressView.backBorderWidth = 0.0;
    self.lineProgressView.frontBorderWidth = 0.0;
    self.lineProgressView.layer.cornerRadius = self.lineProgressView.frame.size.height / 2;
    self.lineProgressView.clipsToBounds = YES;
    self.image.backgroundColor = [UIColor whiteColor];
    self.image.layer.cornerRadius = self.image.frame.size.height / 2;
    self.image.clipsToBounds = YES;
}
@end