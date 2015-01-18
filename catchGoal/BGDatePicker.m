//
//  BGDatePicker.m
//  CatchGoal
//
//  Created by Brusnikin on 1/17/15.
//  Copyright (c) 2015 BrusnikinApp. All rights reserved.
//

#import "BGDatePicker.h"

@interface BGDatePicker ()

@property (strong, nonatomic) NSDateFormatter *dateFormatter;


@end

@implementation BGDatePicker
@synthesize toolbar;

-(instancetype)initWithDateFormatString:(NSString *)dateFromString
                           forTextField:(UITextField *)textField
                     withDatePickerMode:(UIDatePickerMode)datePickerMode {
    
    self = [super init];
    if (self) {

        [self toolbarNew];
        
        self.datePickerMode = datePickerMode;
        self.textField = textField;
        
        self.dateFormatter = [NSDateFormatter new];
        self.dateFormatter.dateFormat = dateFromString;
        
        
        [self addTarget:self
                 action:@selector(dateSelected:)
       forControlEvents:UIControlEventValueChanged];
        
    }
    return self;
    
}

-(void)setDate:(NSDate *)date {
    [super setDate:date];
    [self dateSelected:nil];
}

-(void)dateSelected:(id)sender {
    
    self.textField.text =
    [self.dateFormatter stringFromDate:self.date];
}


#pragma mark - UIToolbar

-(UIToolbar*)toolbarNew {
    
    toolbar =
    [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *flexible =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                 target:nil
                                                 action:nil];
    
    UIBarButtonItem *doneItem =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                 target:self
                                                 action:@selector(doneButtonPressed:)];
    
    toolbar.items = [NSArray arrayWithObjects:flexible, doneItem, nil];

    
    return toolbar;
}

-(void)doneButtonPressed:(UIBarButtonItem*)sender {
    
    UILocalNotification *localNotification = [UILocalNotification new];
    
    localNotification.fireDate = self.date;
    
    NSDate *leftThreeDays =
    //[NSDate dateWithTimeIntervalSinceNow:-(24*60*60)*3];
    [NSDate dateWithTimeIntervalSinceNow:10];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar component:NSCalendarUnitMinute fromDate:leftThreeDays];
    
    localNotification.repeatCalendar = calendar;

    
    localNotification.alertBody = @"Hurry up!";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [localNotification setApplicationIconBadgeNumber:1];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [self.textField resignFirstResponder];
    
}


@end
