//
//  detailNameCell.m
//  catchGoal
//
//  Created by Roman Bogomolov on 15/02/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "goalInfoCell.h"

@implementation goalInfoCell

- (void)awakeFromNib {
    self.goalImage.layer.cornerRadius = self.goalImage.frame.size.height / 2;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
