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
    
    //self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    
    for (UIView* view in self.contentView.subviews) {
        
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField* field = (UITextField*)view;
            
            field.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1];
    //      field.backgroundColor = [UIColor blackColor];
            field.alpha = 0.5;
            field.layer.cornerRadius = 5.f;
            field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
            field.leftViewMode = UITextFieldViewModeAlways;
            
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:field.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:14.f]}];
            
        }
        
        
    }
}



@end
