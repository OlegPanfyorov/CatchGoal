//
//  BGDatePicker.h
//  CatchGoal
//
//  Created by Brusnikin on 1/17/15.
//  Copyright (c) 2015 BrusnikinApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGDatePicker : UIDatePicker

@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UITextField *textField;

-(instancetype)initWithDateFormatString:(NSString*) dateFromString
                           forTextField:(UITextField*)textField
                     withDatePickerMode:(UIDatePickerMode) datePickerMode;


@end
