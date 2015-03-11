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
    //self.backgroundColor = [[UIColor colorWithWhite:1.0 alpha:1.0] colorWithAlphaComponent:0.25];
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