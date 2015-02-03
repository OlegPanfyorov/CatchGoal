//
//  DetailTableViewController.m
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "DetailTableViewController.h"
#import "Goal.h"

@interface DetailTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *previousGoalButton;
@property (weak, nonatomic) IBOutlet UIButton *nextGoalButton;
@property (weak, nonatomic) IBOutlet UILabel *progressMoney;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Goal *goal = [DataSingletone sharedModel].goalsArray[_selectedItemInArray];
    self.nameLabel.text = goal.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", goal.price];
    self.perMonthLabel.text = [NSString stringWithFormat:@"%@ p", goal.perMonth];
    self.totalLabel.text = [NSString stringWithFormat:@"%@", goal.progress];
    self.progressMoney.text = [self calculateProgressInMoney:goal.price goalProgress:goal.progress];
    self.progress = [goal.progress floatValue];
    
    // Delete separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self canGoToPreviousOrNextGoal];
    
    
    [self setupCirculeIndicator];
    //[self setupSmallCircleLabels];
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
    
    Goal *goal = [DataSingletone sharedModel].goalsArray[self.selectedItemInArray];
    self.nameLabel.text = goal.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", goal.price];
    self.perMonthLabel.text = [NSString stringWithFormat:@"%@", goal.perMonth];
    self.totalLabel.text = [NSString stringWithFormat:@"%@", goal.progress];
    self.progressMoney.text = [self calculateProgressInMoney:goal.price goalProgress:goal.progress];
    self.progress = goal.progress.floatValue;
    
    [self setupCirculeIndicator];
}

- (NSString*) calculateProgressInMoney:(NSNumber*) goalPrice goalProgress:(NSNumber*) progress {
    int price = goalPrice.intValue;
    int goalProgress = progress.intValue;
    int progressInMoney = price * goalProgress / 100;
    
    NSString *result = [NSString stringWithFormat:@"%d", progressInMoney];
    return result;
}
//на будущее
- (NSString*) myCurrencyIs {
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *currencySymbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
    NSLog(@"Currency Symbol : %@", currencySymbol);
    NSString *currencyCode = [theLocale objectForKey:NSLocaleCurrencyCode];
    NSLog(@"Currency Code : %@", currencyCode);
    return currencyCode;
}
//
- (IBAction)nextGoalButtonTap:(UIButton *)sender {
    
    self.selectedItemInArray++;

    [self canGoToPreviousOrNextGoal];
    
    Goal *goal = [DataSingletone sharedModel].goalsArray[self.selectedItemInArray];
    self.nameLabel.text = goal.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", goal.price];
    self.perMonthLabel.text = [NSString stringWithFormat:@"%@", goal.perMonth];
    self.totalLabel.text = [NSString stringWithFormat:@"%@", goal.progress];
    self.progressMoney.text = [self calculateProgressInMoney:goal.price goalProgress:goal.progress];
    self.progress = goal.progress.floatValue;
    [self setupCirculeIndicator];
}

- (void) setupSmallCircleLabels {
    
    for (KAProgressLabel* object in self.smallCircleLabals) {
        object.progressLabelVCBlock = ^(KAProgressLabel *label, CGFloat progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [label setText:[NSString stringWithFormat:@"%.0f%%", (progress*100)]];
                [label setTextColor:[UIColor darkGrayColor]];
                [label setFont:[UIFont systemFontOfSize:12.f]];
            });
        };
        
        [object setBackBorderWidth: 3.0];
        [object setFrontBorderWidth: 3.0];
        
        
        [object setColorTable: @{
                                            NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):
                                                [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1],
                                            NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                                [UIColor colorWithRed:1 green:0.26 blue:0.3 alpha:1],
                                            }];
        
        switch (object.tag) {
            case 0:
                [object setProgress:50.f/100.f timing:TPPropertyAnimationTimingEaseIn duration:2.f delay:0];
                break;
            case 1:
                [object setProgress:75.f/100.f timing:TPPropertyAnimationTimingEaseIn duration:2.f delay:0];
                [object setColorTable: @{
                                         NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):
                                             [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1],
                                         NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                             [UIColor colorWithRed:0.97 green:0.88 blue:0.45 alpha:1],
                                         }];
                break;
            case 2:
                [object setProgress:30.f/100.f timing:TPPropertyAnimationTimingEaseIn duration:2.f delay:0];
                [object setColorTable: @{
                                         NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):
                                             [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1],
                                         NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                             [UIColor greenColor],
                                         }];
                break;
                
            default:
                break;
        }
        
    }
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
    
    [self.circleProgressLabel setProgress:self.progress / 100 timing:TPPropertyAnimationTimingEaseOut duration:2.f delay:0.3];
}


@end
