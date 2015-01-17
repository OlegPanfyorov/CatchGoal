//
//  DetailTableViewController.m
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Delete separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupCirculeIndicator];
    [self SetSumLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)previewsGoalButtonTap:(id)sender {
    
}

- (IBAction)nextGoalButtonTap:(id)sender {
    
}
- (void) SetSumLeft {
    
    self.sumLeftLabel.progressLabelVCBlock = ^(KAProgressLabel *label, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [label setText:[NSString stringWithFormat:@"%.0f%%", (progress*100)]];
            [label setTextColor:[UIColor darkGrayColor]];
            [label setFont:[UIFont systemFontOfSize:12.f]];
        });
    };
    
    [self.sumLeftLabel setBackBorderWidth: 3.0];
    [self.sumLeftLabel setFrontBorderWidth: 3.0];
    
    
    [self.sumLeftLabel setColorTable: @{
                                               NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):
                                                   [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1],
                                               NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                                   [UIColor colorWithRed:1 green:0.26 blue:0.3 alpha:1],
                                               }];
    
    [self.sumLeftLabel setProgress:50.f/100.f timing:TPPropertyAnimationTimingEaseIn duration:2.f delay:0];
}

- (void) setupCirculeIndicator {
    
    self.circleProgressLabel.progressLabelVCBlock = ^(KAProgressLabel *label, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [label setText:[NSString stringWithFormat:@"%.0f%%", (progress*100)]];
            [label setTextColor:[UIColor darkGrayColor]];
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
    
    [self.circleProgressLabel setProgress:50.f/100.f timing:TPPropertyAnimationTimingEaseIn duration:2.f delay:0];

    
}

@end
