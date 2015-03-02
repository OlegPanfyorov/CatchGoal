//
//  LaunchScreenViewController.m
//  catchGoal
//
//  Created by Oleg Panforov on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "LoginViewController.h"
#import "GoalsViewController.h"


@interface LaunchScreenViewController ()


@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void) viewWillAppear:(BOOL)animated {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        GoalsViewController  *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
        [self.navigationController pushViewController:mainVC animated:NO];
    } else {
        // show the signup or login screen
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self.navigationController pushViewController:loginVC animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
