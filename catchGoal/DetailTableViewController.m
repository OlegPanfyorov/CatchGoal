//
//  DetailTableViewController.m
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "DetailTableViewController.h"
#import "Goal.h"
#import "goalInfoCell.h"

#define CURRENCY_SYMBOL [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]

@interface DetailTableViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *goalImage;
@property (weak, nonatomic) IBOutlet UIButton *previousGoalButton;
@property (weak, nonatomic) IBOutlet UIButton *nextGoalButton;
@property (weak, nonatomic) IBOutlet UILabel *progressMoney;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalDateLabel;
@property (assign, nonatomic) CGFloat progressPercent;
@property (assign, nonatomic) int sumLeft;
@property (assign, nonatomic) int addMoneySum;


-(IBAction)addMoneyClicked:(UIBarButtonItem*)sender;


@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.alwaysBounceVertical = NO;
    
    [self setupGoalInfo];
    
    [self canGoToPreviousOrNextGoal];
    [self setupCirculeIndicator];
    
}



- (void) setupGoalInfo {
    Goal *goal = [DataSingletone sharedModel].goalsArray[_selectedItemInArray];
    self.nameLabel.text = goal.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %@", goal.price, CURRENCY_SYMBOL];
    self.progressMoney.text = [NSString stringWithFormat:@"%@ %@", goal.progress, CURRENCY_SYMBOL];
    self.progressPercent = [goal.progress floatValue] / [goal.price floatValue];
    self.sumLeft = [goal.price intValue] - [goal.progress intValue];
    
    self.startDateLabel.text = [NSString stringWithFormat:@"Начало: %@", [self convertDateToString:goal.startDate]];
    self.finalDateLabel.text = [NSString stringWithFormat:@"Финал: %@", [self convertDateToString:goal.finalDate]];
    self.goalImage.image = goal.goalImage;
    self.goalImage.layer.cornerRadius = self.goalImage.frame.size.height / 2;
    
    NSLog(@"sumLeft %d", self.sumLeft);
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)canGoToPreviousOrNextGoal {
    
    // For previews button
    if (self.selectedItemInArray == 0) {
        self.previousGoalButton.hidden = YES;
        // For next button
    } else {
        self.previousGoalButton.hidden = NO;
    }
    
    if (self.selectedItemInArray + 2 > [[DataSingletone sharedModel].goalsArray count]) {
        self.nextGoalButton.hidden = YES;
    } else {
        self.nextGoalButton.hidden = NO;
    }
}

#pragma mark - Actions

- (IBAction)previousGoalButtonTap:(UIButton *)sender {

    self.selectedItemInArray--;
    [self canGoToPreviousOrNextGoal];
    [self setupGoalInfo];
    [self setupCirculeIndicator];
}


- (IBAction)nextGoalButtonTap:(UIButton *)sender {
    
    self.selectedItemInArray++;
    [self canGoToPreviousOrNextGoal];
    [self setupGoalInfo];
    [self setupCirculeIndicator];
}

-(IBAction)addMoneyClicked:(UIBarButtonItem*)sender {
    
    NSLog(@"sumLeft %d", self.sumLeft);
    UIAlertView *addMoney = [[UIAlertView alloc] initWithTitle:@"Внесите сумму:"
                                                           message:[NSString stringWithFormat:@"До достижения цели осталось внести: %d %@", self.sumLeft, CURRENCY_SYMBOL]
                                                          delegate:self
                                                 cancelButtonTitle:@"Отмена"
                                                 otherButtonTitles:@"Ок", nil];
    
    addMoney.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[addMoney textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [addMoney show];
    //[[addMoney textFieldAtIndex:0] becomeFirstResponder];
}


-(NSString*) convertDateToString:(NSDate*) dateToConvert {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"dd.MM.yyyy"]; // Date formater
    NSString *date = [dateFormater stringFromDate:dateToConvert]; // Convert date to string
    return date;
}


- (void) setupCirculeIndicator {
    
    [self.circleProgressLabel setProgress:0];
    self.circleProgressLabel.progressLabelVCBlock = ^(KAProgressLabel *label, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [label setText:[NSString stringWithFormat:@"%.0f%%", (progress*100)]];
            [label setTextColor:[UIColor colorWithRed:0.42 green:0.82 blue:0.28 alpha:1]];
            [label setFont:[UIFont systemFontOfSize:40.f]];
            
        });
    };
    [self.circleProgressLabel setBackBorderWidth: 7.5];
    [self.circleProgressLabel setFrontBorderWidth: 7.5];
    
    [self.circleProgressLabel setColorTable: @{
                                  NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):
                                      [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1],
                                  NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                      [UIColor colorWithRed:0 green:0.69 blue:0.96 alpha:1],
                                  }];
    [self.circleProgressLabel setProgress:self.progressPercent timing:TPPropertyAnimationTimingEaseOut duration:2.f delay:0.0];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput && buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        self.addMoneySum = [textField.text intValue];
        
        // Make sure that the given number is between 1 and 100.
        if (self.addMoneySum >= 1 && self.addMoneySum <= self.sumLeft) {
            
        } else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:[NSString stringWithFormat:@"Введенная Вами сумма не должна превышать %d %@", self.sumLeft, CURRENCY_SYMBOL]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Ок", nil];
            [alert show];
        }
    }
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Операции";
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 303;
    } else
        
        return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else
    
    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        Goal *goal = [DataSingletone sharedModel].goalsArray[indexPath.row];
        
        static NSString* infoCellIdentifier = @"infoCell";
        
        goalInfoCell* infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
        
        infoCell.goalName.text = goal.name;
        infoCell.totalSum.text = [NSString stringWithFormat:@"%@ %@", goal.price, CURRENCY_SYMBOL];
        infoCell.progressMoney.text = [NSString stringWithFormat:@"%@ %@", goal.progress, CURRENCY_SYMBOL];
        infoCell.startDateLabel.text = [NSString stringWithFormat:@"Начало: %@", [self convertDateToString:goal.startDate]];
        infoCell.finishDateLabel.text = [NSString stringWithFormat:@"Финал: %@", [self convertDateToString:goal.finalDate]];
        infoCell.image.image = goal.goalImage;
        
        [infoCell.circleProgressLabel setProgress:0];
        infoCell.circleProgressLabel.progressLabelVCBlock = ^(KAProgressLabel *label, CGFloat progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [label setText:[NSString stringWithFormat:@"%.0f%%", (progress*100)]];
                [label setTextColor:[UIColor colorWithRed:0.42 green:0.82 blue:0.28 alpha:1]];
                [label setFont:[UIFont systemFontOfSize:40.f]];
                
            });
        };
        [infoCell.circleProgressLabel setBackBorderWidth: 7.5];
        [infoCell.circleProgressLabel setFrontBorderWidth: 7.5];
        
        [infoCell.circleProgressLabel setColorTable: @{
                                                   NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):
                                                       [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1],
                                                   NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                                       [UIColor colorWithRed:0 green:0.69 blue:0.96 alpha:1],
                                                   }];
        [infoCell.circleProgressLabel setProgress:self.progressPercent timing:TPPropertyAnimationTimingEaseOut duration:2.f delay:0.0];
        
        return infoCell;
        
    } else {
        
        static NSString* operationsCellIdentifier = @"operationsCell";
        
        goalInfoCell* operationsCell = [tableView dequeueReusableCellWithIdentifier:operationsCellIdentifier];
        
        return operationsCell;
        
    }
    
    return nil;

}


@end
