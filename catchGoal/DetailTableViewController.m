//
//  DetailTableViewController.m
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "DetailTableViewController.h"
#include "Goal.h"
#import "GoalOperations.h"
#import "goalInfoCell.h"
#import "goalOperationsCell.h"
#import "SCLAlertView.h"

#define CURRENCY_SYMBOL [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]

@interface DetailTableViewController () <UIAlertViewDelegate>

@property (assign, nonatomic) CGFloat progressPercent;
@property (assign, nonatomic) int sumLeft;
@property (assign, nonatomic) int addMoneySum;
@property (strong, nonatomic) NSMutableArray* goalOperationsArray;

-(IBAction)addMoneyClicked:(UIBarButtonItem*)sender;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.alwaysBounceVertical = NO;
    [self fetchAllGoalOperations];
    
 
}

- (void)fetchAllGoalOperations {
    Goal *goal = [DataSingletone sharedModel].goalsArray[self.selectedItemInArray];
    self.goalOperationsArray = [NSMutableArray array];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"addDate" ascending:NO]];
    NSArray *sortedOperatoins = [[goal.operations allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    self.goalOperationsArray = [NSMutableArray arrayWithArray:sortedOperatoins];
    
    if ([goal.complited boolValue]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)previousGoalButtonTap:(UIButton *)sender {
    self.selectedItemInArray--;
    [self fetchAllGoalOperations];
    [self.tableView reloadData];    
}

- (IBAction)nextGoalButtonTap:(UIButton *)sender {
    self.selectedItemInArray++;
    [self fetchAllGoalOperations];
    [self.tableView reloadData];
}

-(IBAction)addMoneyClicked:(UIBarButtonItem*)sender {
    self.tableView.scrollEnabled = NO;
    sender.enabled = NO;
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SlideInFromTop;
    alert.backgroundType = Blur;

    UITextField *textField = [alert addTextField:@"Сумма"];
   // [textField becomeFirstResponder];

    [alert addButton:@"Готово" actionBlock:^(void) {
        self.addMoneySum = [textField.text intValue];

        if (self.addMoneySum >= 1 && self.addMoneySum <= self.sumLeft && self.addMoneySum != self.sumLeft) {
            [self addNewSumToContextWithCompletedFlag:NO];
            sender.enabled = YES;
        } else if (self.addMoneySum == self.sumLeft) {
           
            SCLAlertView *alertWithComplited = [[SCLAlertView alloc] init];
            [alertWithComplited showSuccess:self title:@"Завершено" subTitle:@"Вы выполнили данную цель." closeButtonTitle:@"Готово" duration:0.0f];
            [self addNewSumToContextWithCompletedFlag:YES];
            [alertWithComplited alertIsDismissed:^{
                self.tableView.scrollEnabled = YES;
                sender.enabled = YES;
            }];


        } else {
            
            SCLAlertView *alertWithError = [[SCLAlertView alloc] init];
            [alertWithError showError:self title:@"Ошибка" subTitle:[NSString stringWithFormat:@"Введенная вами сумма не должна превышать %d %@", self.sumLeft, CURRENCY_SYMBOL] closeButtonTitle:@"OK" duration:0.0f]; // Error
            alertWithError.showAnimationType = SlideInFromTop;
            
            [alertWithError alertIsDismissed:^{
                self.tableView.scrollEnabled = YES;
                sender.enabled = YES;
                
            }];
        }
    }];
    
    [alert addButton:@"Отмена" actionBlock:^(void) {
        self.tableView.scrollEnabled = YES;
        sender.enabled = YES;

    }];
    
    [alert showSuccess:self title:@"Внесите сумму"
                            subTitle:[NSString stringWithFormat:@"До достижения цели осталось собрать: %d %@", self.sumLeft, CURRENCY_SYMBOL]
                            closeButtonTitle:nil duration:0.0f];
}

- (void) addNewSumToContextWithCompletedFlag:(BOOL) isCompleted {
    Goal *goal = [DataSingletone sharedModel].goalsArray[self.selectedItemInArray];
    goal.complited = [NSNumber numberWithBool:isCompleted];
    self.operations = [GoalOperations createEntity];
    self.operations.addSum = [NSNumber numberWithInt: self.addMoneySum];
    self.operations.addDate = [NSDate date];
    [goal addOperationsObject:self.operations];
    goal.progress = [NSNumber numberWithInt:self.addMoneySum + [goal.progress intValue]];
    [self.goalOperationsArray insertObject:self.operations atIndex:0];
    [[DataSingletone sharedModel] saveContext];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    self.tableView.scrollEnabled = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.37 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(NSString*) convertDateToString:(NSDate*) dateToConvert {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"dd.MM.yyyy : hh.mm"];
    NSString *date = [dateFormater stringFromDate:dateToConvert];
    NSString* subString = [date substringToIndex:10];
    return subString;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 20;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return [NSString stringWithFormat:@"    Операции (%lu)", (unsigned long)[self.goalOperationsArray count]];
    } else {
        return nil;
    }
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
        return [self.goalOperationsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Goal *goal = [DataSingletone sharedModel].goalsArray[self.selectedItemInArray];

    if (indexPath.section == 0) {
        self.navigationItem.title = goal.name;
        static NSString* infoCellIdentifier = @"infoCell";
        goalInfoCell* infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
        self.sumLeft = [goal.price floatValue] - [goal.progress floatValue];
        if (self.selectedItemInArray == 0) {
            infoCell.previousGoalButton.hidden = YES;
            // For next button
        } else {
            infoCell.previousGoalButton.hidden = NO;
        }
        
        if (self.selectedItemInArray + 2 > [[DataSingletone sharedModel].goalsArray count]) {
            infoCell.nextGoalButton.hidden = YES;
        } else {
            infoCell.nextGoalButton.hidden = NO;
        }
        
        infoCell.nameLabel.text = goal.name;
        infoCell.priceLabel.text = [NSString stringWithFormat:@"%@ %@ собрано из %@ %@", goal.progress, CURRENCY_SYMBOL, goal.price, CURRENCY_SYMBOL];
        infoCell.progressMoney.text = [NSString stringWithFormat:@"%@ %@", goal.progress, CURRENCY_SYMBOL];
        infoCell.startDateLabel.text = [NSString stringWithFormat:@"Начало: %@", [self convertDateToString:goal.startDate]];
        infoCell.finalDateLabel.text = [NSString stringWithFormat:@"Финал: %@", [self convertDateToString:goal.finalDate]];
        
        NSData *goalImage = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:goal.imagePath]];
        if (goal.imagePath) {
            infoCell.goalImage.image = [UIImage imageWithData:goalImage];
        } else {
            infoCell.goalImage.image = [UIImage imageNamed:@"no_photo"];
        }
        
        self.progressPercent = [goal.progress floatValue] / [goal.price floatValue];
    
       // [infoCell.circleProgressLabel setProgress:0];
        infoCell.circleProgressLabel.progressLabelVCBlock = ^(KAProgressLabel *label, CGFloat progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [label setText:[NSString stringWithFormat:@"%.0f%%", (progress*100)]];
                [label setTextColor:[UIColor colorWithRed:0.42 green:0.82 blue:0.28 alpha:1]];
                [label setFont:[UIFont systemFontOfSize:50.f]];
                
            });
        };
        
        [infoCell.circleProgressLabel setBackBorderWidth: 8];
        [infoCell.circleProgressLabel setFrontBorderWidth: 8];
        
        [infoCell.circleProgressLabel setColorTable: @{
                                                   NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):
                                                       [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1],
                                                   NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                                       [UIColor colorWithRed:0 green:0.69 blue:0.96 alpha:1],
                                                   }];
        [infoCell.circleProgressLabel setProgress:self.progressPercent timing:TPPropertyAnimationTimingEaseOut duration:2.f delay:0.0];
        [infoCell.nextGoalButton addTarget:self action:@selector(nextGoalButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [infoCell.previousGoalButton addTarget:self action:@selector(previousGoalButtonTap:) forControlEvents:UIControlEventTouchUpInside];

        return infoCell;
        
    } else {
        static NSString* operationsCellIdentifier = @"operationsCell";
        goalOperationsCell* operationsCell = [tableView dequeueReusableCellWithIdentifier:operationsCellIdentifier];
        self.operations = [self.goalOperationsArray objectAtIndex:indexPath.row];
        operationsCell.sumLabel.text = [NSString stringWithFormat:@"%@ %@", [self.operations.addSum stringValue], CURRENCY_SYMBOL];
        operationsCell.dateLabel.text = [self convertDateToString:self.operations.addDate];
        return operationsCell;
    }

    return nil;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets insets = {28,0,0,0};
    self.tableView.contentInset = insets;
    
    // Force your tableview margins (this may be a bad idea)
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
