//
//  LaunchScreenViewController.m
//  catchGoal
//
//  Created by Oleg Panforov on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "LoginViewController.h"
#import "GoalsTableViewController.h"

@interface LaunchScreenViewController ()


@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        GoalsTableViewController  *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
        [self.navigationController pushViewController:mainVC animated:YES];
        
    } else {
        // show the signup or login screen
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
