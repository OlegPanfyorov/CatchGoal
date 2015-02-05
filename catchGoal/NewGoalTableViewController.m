//
//  NewGoalTableViewController.m
//  catchGoal
//
//  Created by Brusnikin on 1/18/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#define kNavBarColorBlue [UIColor colorWithRed:0.32 green:0.64 blue:0.9 alpha:1]
#define kNavBarColorGreen [UIColor colorWithRed:0.52 green:0.98 blue:0.49 alpha:1]

#import "NewGoalTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "RMDateSelectionViewController.h"

static NSInteger const kNavAndStatusBarHeight = 64;

@interface NewGoalTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    DataSingletone *singletone;
}

@property (weak, nonatomic) IBOutlet UITextField *goalName;
@property (weak, nonatomic) IBOutlet UITextField *totalCost;
@property (weak, nonatomic) IBOutlet UITextField *progressInMoney;
@property (weak, nonatomic) IBOutlet UITextField *finalDate;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation NewGoalTableViewController
@synthesize photo, goalName, totalCost;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton addTarget:self action:@selector(addNewGoal) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = CGRectMake(0, self.tableView.frame.size.height - kNavAndStatusBarHeight * 2, self.view.frame.size.width, kNavAndStatusBarHeight);
    saveButton.backgroundColor = kNavBarColorBlue;
    [saveButton setTitle:@"Сохранить" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:saveButton];
    
    self.tableView.alwaysBounceVertical = NO;
    self.photo.layer.cornerRadius = self.photo.frame.size.width / 2;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        
    UIBarButtonItem *cancelItem =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:self
                                                 action:@selector(cancelToBack)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //hide keyboard on BG tap
    UITapGestureRecognizer *singleTap;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(showDatePicker)];
    singleTap.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = TRUE;
    [self.finalDate addGestureRecognizer:singleTap];
    
}

-(void) showDatePicker {
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    
    dateSelectionVC.hideNowButton = YES;
    
    //You can enable or disable bouncing and motion effects
    dateSelectionVC.disableBouncingWhenShowing = YES;
    dateSelectionVC.disableMotionEffects = YES;
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionVC.datePicker.minuteInterval = 5;
    NSDate *datePlusMonth = [NSDate date];
    datePlusMonth = [datePlusMonth dateByAddingTimeInterval:(30 * 24 * 60 * 60)];
    dateSelectionVC.datePicker.date = datePlusMonth;

    [dateSelectionVC showWithSelectionHandler:^(RMDateSelectionViewController *vc, NSDate *aDate) {
        NSLog(@"Successfully selected date: %@ (With block)", aDate);
        self.finalDate.text = [self convertDateToString:aDate];
    } andCancelHandler:^(RMDateSelectionViewController *vc) {
        NSLog(@"Date selection was canceled (with block)");
        self.finalDate.text = [self convertDateToString:datePlusMonth];
    }];
}

-(NSString*) convertDateToString:(NSDate*) date {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM, yyyy"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    format.locale = usLocale;
    NSString *theDate = [format stringFromDate:date];
    NSLog(@"%@", date);
    
    return theDate;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    switch (textField.tag) {
        case 0:
            [self.totalCost becomeFirstResponder];
            break;
        case 1:
            [self.progressInMoney becomeFirstResponder];
            break;
        case 2:
            [textField resignFirstResponder];
            [self.finalDate becomeFirstResponder];
            break;
        case 3:
            [textField resignFirstResponder];
            break;
        default:
            break;
    }
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 3) {
        [self.finalDate resignFirstResponder];
        [self showDatePicker];
    }
}

#pragma mark - Actions

-(void)addNewGoal {
    
    NSLog(@"New Goal was created");
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelToBack {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
 
    return 16.0;
}
*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
