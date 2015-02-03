//
//  addAndEditGoalCell.m
//  catchGoal
//
//  Created by Roman Bogomolov on 27/01/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "addAndEditGoalCell.h"

@implementation addAndEditGoalCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];

    for (UIView* view in self.contentView.subviews) {
        
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField* field = (UITextField*)view;
            
            field.layer.cornerRadius = 5.f;
            field.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;
            field.layer.borderWidth = 1.f;
            field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
            field.leftViewMode = UITextFieldViewModeAlways;
            
        } else if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView* imageView = (UIImageView*)view;
            
            imageView.layer.cornerRadius = 5.f;
            imageView.layer.borderWidth = 1.f;
            imageView.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1].CGColor;

        }
        
        
    }
}



@end
