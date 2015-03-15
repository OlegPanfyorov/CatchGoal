//
//  detailOpetatinsCell.m
//  catchGoal
//
//  Created by Roman Bogomolov on 15/02/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "goalOperationsCell.h"

@implementation goalOperationsCell

- (void)awakeFromNib {
    self.sumLabel.textColor = [UIColor colorWithRed:0.42 green:0.82 blue:0.28 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [[UIColor colorWithWhite:1.0 alpha:1] colorWithAlphaComponent:0.1];
    
    self.dateLabel.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
