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
    
    UIView* circle = [[UIView alloc] initWithFrame:CGRectMake(10, 19, 7, 7)];
    circle.backgroundColor = [UIColor whiteColor];
    circle.layer.cornerRadius = circle.frame.size.height / 2;
    
    if (self.tag == 0) {
        [self addSubview:circle];
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    
    for (UIView* view in self.contentView.subviews) {
        
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField* field = (UITextField*)view;
            field.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
            field.backgroundColor = [[UIColor colorWithWhite:1.0 alpha:1.0] colorWithAlphaComponent:0.25];
            field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
            field.leftViewMode = UITextFieldViewModeAlways;
            field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:field.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.75], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Medium" size:14.f]}];
            
        }
        
        
    }
}



@end
