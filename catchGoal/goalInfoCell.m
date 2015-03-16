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
    self.goalImageButton.layer.cornerRadius = self.goalImageButton.frame.size.height / 2;
    self.backgroundColor = [UIColor clearColor];
    self.headerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.mediaDataView.backgroundColor = [UIColor clearColor];
     
    for (UIButton* button in self.showButtons) {
        button.backgroundColor = [UIColor clearColor];
//        button.layer.cornerRadius = button.frame.size.height / 2;
//        button.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.2].CGColor;
//        button.layer.borderWidth = 1;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)photoButtonTapped:(UIButton *)sender
{
    [self.delegate showPhoto];
}

@end
