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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)previewsGoalButtonTap:(id)sender {
    
}

- (IBAction)nextGoalButtonTap:(id)sender {
    
}

- (void) setupCirculeIndicator {
    
    self.circleProgressLabel.progressLabelVCBlock = ^(KAProgressLabel *label, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [label setText:[NSString stringWithFormat:@"%.0f%%", (progress*100)]];
        });
    };
    
    [self.circleProgressLabel setBackBorderWidth: 7.5];
    [self.circleProgressLabel setFrontBorderWidth: 7.5];
    
    
    [self.circleProgressLabel setColorTable: @{
                                  NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):
                                      [UIColor lightGrayColor],
                                  NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                      [UIColor colorWithRed:0.97 green:0.88 blue:0.45 alpha:1],
                                  }];
    
    [self.circleProgressLabel setProgress:50.f/100.f timing:TPPropertyAnimationTimingEaseIn duration:2.f delay:0];

    
}

@end
