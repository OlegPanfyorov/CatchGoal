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
    
    self.lineProgressView.progressType = ProgressLabelRect;
    self.lineProgressView.backBorderWidth = 0.0;
    self.lineProgressView.frontBorderWidth = 0.0;
    self.lineProgressView.layer.cornerRadius = self.lineProgressView.frame.size.height / 2;
    self.lineProgressView.clipsToBounds = YES;
    
    [self.lineProgressView setColorTable: @{
                                           NSStringFromProgressLabelColorTableKey(ProgressLabelFillColor):
                                               [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1],
                                           NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                               [UIColor colorWithRed:0.42 green:0.82 blue:0.28 alpha:1],
                                           }];
    
    self.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.99 alpha:1];
    
    self.progressLabel.backgroundColor = [UIColor whiteColor];
    self.progressLabel.layer.cornerRadius = self.progressLabel.frame.size.height / 2;
    self.progressLabel.layer.borderWidth = 1.f;
    self.progressLabel.layer.borderColor = [UIColor colorWithRed:0.33 green:0.64 blue:0.9 alpha:0.25].CGColor;
    self.progressLabel.clipsToBounds = YES;

}
@end