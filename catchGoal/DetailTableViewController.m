//
//  DetailTableViewController.m
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "DetailTableViewController.h"
#import "Goal.h"

#define CURRENCY_SYMBOL [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]

@interface DetailTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *goalImage;
@property (weak, nonatomic) IBOutlet UIButton *previousGoalButton;
@property (weak, nonatomic) IBOutlet UIButton *nextGoalButton;
@property (weak, nonatomic) IBOutlet UILabel *progressMoney;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalDateLabel;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.alwaysBounceVertical = NO;
    
    [self setupGoalInfo];
    
    // Delete separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self canGoToPreviousOrNextGoal];
    [self setupCirculeIndicator];
}

- (void) setupGoalInfo {
    Goal *goal = [DataSingletone sharedModel].goalsArray[_selectedItemInArray];
    self.nameLabel.text = goal.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %@", goal.price, CURRENCY_SYMBOL];
    self.progressMoney.text = [NSString stringWithFormat:@"%@ %@", goal.progress, CURRENCY_SYMBOL];
    self.progressPercent = [goal.progress floatValue] / [goal.price floatValue];
    self.startDateLabel.text = [NSString stringWithFormat:@"Начало: %@", [self convertDateToString:goal.startDate]];
    self.finalDateLabel.text = [NSString stringWithFormat:@"Финал: %@", [self convertDateToString:goal.finalDate]];
    self.goalImage.image = goal.goalImage;
    self.goalImage.layer.cornerRadius = self.goalImage.frame.size.height / 2;
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


@end
