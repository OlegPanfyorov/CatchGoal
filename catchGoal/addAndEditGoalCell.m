//
//  addAndEditGoalCell.m
//  catchGoal
//
//  Created by Roman Bogomolov on 27/01/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "AddAndEditGoalCell.h"

@implementation AddAndEditGoalCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    for (UIView* view in self.contentView.subviews) {
        
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField* field = (UITextField*)view;
            
            field.alpha = 0.85;
            field.layer.cornerRadius = 5.f;
            field.layer.borderColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor;
            field.layer.borderWidth = 1.f;
            field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
            field.leftViewMode = UITextFieldViewModeAlways;
            
        } 
        
        
    }
}



@end
