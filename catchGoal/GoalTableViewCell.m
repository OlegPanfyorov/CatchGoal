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


}
@end