//
//  LoginViewController.m
//  catchGoal
//
//  Created by Oleg Panforov on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "ForgotPasswordViewController.h"
#import "GoalsTableViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)registrationClicked:(UIButton *)sender;
- (IBAction)forgotPasswordClicked:(UIButton *)sender;
- (IBAction)loginClicked:(UIButton *)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = YES;
    self.wrapFieldsLabel.layer.cornerRadius = 5.f;
    self.loginButton.layer.cornerRadius = 5.f;
    
    self.loginTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 45)];
    self.loginTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 45)];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
       
    if ([self.loginTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        self.loginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.loginTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:18.f]}];
    }
    
    if ([self.passwordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:18.f]}];
    }

}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.loginTextField.text = @"";
    self.passwordTextField.text = @"";

}

#pragma mark - Keyboard

-(void) hideKeyboard {
    [self.loginTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    switch (textField.tag) {
        case 0:
            [self.passwordTextField becomeFirstResponder];
            break;
        case 1:
            [textField resignFirstResponder];
            break;
        default:
            break;
    }
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == 0) {           //login
        return YES;
    } else {                            //email
        NSString *myString = string;
        NSCharacterSet *illegalChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        // Test if there is an illegal character in the string
        BOOL hasIllegalCharacter = [myString rangeOfCharacterFromSet:illegalChars].location != NSNotFound;
        BOOL hasLetter = [myString rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound;
        BOOL hasDigit  = [myString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
            if (!hasDigit  && !hasLetter  && hasIllegalCharacter  ) {
                return NO;
            }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 30) ? NO : YES;
    }

}

#pragma mark - Actions

- (IBAction)registrationClicked:(UIButton *)sender {
    
    RegistrationViewController *registrationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"registrationVC"];
    [self.navigationController pushViewController:registrationVC animated:YES];
}

- (IBAction)forgotPasswordClicked:(UIButton *)sender {
    
    ForgotPasswordViewController *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"forgotVC"];
    [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}

- (IBAction)loginClicked:(UIButton *)sender {
    
    if ([self.loginTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка"
                                    message:@"Заполните поля логин и пароль"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
    } else {
        [self hideKeyboard];
        [self loginRequest:self.loginTextField.text withPassword:self.passwordTextField.text];
    }
}

#pragma mark - API Requests

-(void) loginRequest:(NSString*)login withPassword:(NSString*) password {
    
    [PFUser logInWithUsernameInBackground:login password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"successful login");
            GoalsTableViewController  *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
            [self.navigationController pushViewController:mainVC animated:YES];

        } else {
            NSLog(@"failed login");
            // The login failed. Check error to see why.
        }
    }];
}




@end
