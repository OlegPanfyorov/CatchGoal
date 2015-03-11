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
            
            field.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            field.backgroundColor = [[UIColor colorWithWhite:1.0 alpha:1.0] colorWithAlphaComponent:0.25];
           // field.backgroundColor = [UIColor blackColor];
           // field.alpha = 0.4;
            field.layer.cornerRadius = 21.f;
            field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
            field.leftViewMode = UITextFieldViewModeAlways;
            
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:field.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.75], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Medium" size:14.f]}];
            
        }
        
        
    }
}



@end
