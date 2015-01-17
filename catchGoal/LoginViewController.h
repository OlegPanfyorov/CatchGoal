//
//  LoginViewController.h
//  catchGoal
//
//  Created by Oleg Panforov on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController : StartScreensMainViewController
@property (weak, nonatomic) IBOutlet UIButton *restoreButtone;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;

@property (weak, nonatomic) IBOutlet UIView *wrapFieldsLabel;
@end
