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
#import "RegistrationViewController.h"
#import "ForgotPasswordViewController.h"

typedef NS_ENUM(NSInteger, Buttons) {
    Login = 0,
    Registration,
    forgotPassword,
};

@interface LaunchScreenViewController ()

@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UILabel *workHard;

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

}
- (void) viewWillAppear:(BOOL)animated {
    self.buttonsView.alpha = 0.0f;
    self.workHard.alpha = 0.0f;
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        GoalsViewController  *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
        [self.navigationController pushViewController:mainVC animated:NO];
    } else {
        [UIView animateWithDuration:1.2f animations:^{
            self.buttonsView.alpha = 0.75f;
            self.workHard.alpha = 0.8f;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (IBAction)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case Login: {
            LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            [self presentViewController:loginVC animated:NO completion:nil];
        }
            break;
        case Registration: {
            RegistrationViewController *registrationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"registrationVC"];
            [self presentViewController:registrationVC animated:NO completion:nil];
        }
            break;
        case forgotPassword: {
            ForgotPasswordViewController *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"forgotVC"];
            [self presentViewController:forgotPasswordVC animated:NO completion:nil];
        }
            break;
            
        default:
            break;
    }
}


@end
