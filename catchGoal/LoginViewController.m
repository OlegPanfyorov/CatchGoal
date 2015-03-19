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
#import "GoalsViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginClicked:(UIButton *)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;

    self.wrapFieldsLabel.layer.cornerRadius = 5.f;
    self.wrapFieldsLabel.layer.borderWidth = 1;
    self.wrapFieldsLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.11];
    self.wrapFieldsLabel.layer.borderColor = [UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:0.20].CGColor;
    self.loginButton.layer.cornerRadius = 5.f;
    
    self.loginTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 45)];
    self.loginTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 45)];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
       
    if ([self.loginTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        self.loginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.loginTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:16.f]}];
    }
    
    if ([self.passwordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:16.f]}];
    }
    
    [self.loginButton addTarget:self action:@selector(lowAlfa:) forControlEvents:UIControlEventTouchDown];
    [self.loginButton addTarget:self action:@selector(hightAlfa:)
              forControlEvents:UIControlEventTouchUpInside |
     UIControlEventTouchDragOutside |
     UIControlEventTouchDragExit |
     UIControlEventTouchUpOutside];
}

- (void) lowAlfa:(UIButton*) sender {
    sender.alpha = 0.5f;
}

- (void) hightAlfa:(UIButton*) sender {
    sender.alpha = 1.f;
}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.loginTextField.text = @"";
    self.passwordTextField.text = @"";
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Underline Button text

-(void) underlineString:(NSString*) string button: (UIButton*) button {
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName
                      value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]
                      range:(NSRange){0,[attString length]}];
    button.titleLabel.attributedText = attString;
    
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

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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
    [self showHUD];
    [PFUser logInWithUsernameInBackground:login password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"successful login");
            [self hideHUD];
            
            [[DataSingletone sharedModel] downloadFromParse];
            
            [self dismissViewControllerAnimated:NO completion:^{
                GoalsViewController  *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
                [self.navigationController pushViewController:mainVC animated:YES];
            }];
        } else {
            [self hideHUD];
            NSLog(@"failed login");
            // The login failed. Check error to see why.
        }
    }];
}




@end
