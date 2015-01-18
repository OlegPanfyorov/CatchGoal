//
//  NewGoalTableViewController.m
//  catchGoal
//
//  Created by Brusnikin on 1/18/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "NewGoalTableViewController.h"
#import "BGDatePicker.h"

@interface NewGoalTableViewController ()

@property (strong, nonatomic) BGDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDeadline;

@end

@implementation NewGoalTableViewController
@synthesize datePicker, textFieldDeadline;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    datePicker =
    [[BGDatePicker alloc]initWithDateFormatString:@"dd.MM.yyyy"
                                     forTextField:textFieldDeadline
                               withDatePickerMode:UIDatePickerModeDateAndTime];
    
    datePicker.date = [NSDate date];
    
    textFieldDeadline.inputView = datePicker;
    textFieldDeadline.inputAccessoryView = datePicker.toolbar;
    
    UIBarButtonItem *cancelItem =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:self
                                                 action:@selector(cancelToBack)];
    
    UIBarButtonItem *saveItem =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                 target:self
                                                 action:@selector(addNewGoal)];
    
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)addNewGoal {
    
    NSLog(@"New Goal was created");
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelToBack {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
