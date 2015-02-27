//
//  RegistrationViewController.m
//  catchGoal
//
//  Created by Oleg Panforov on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *wrapView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)backButtonPressed:(UIButton *)sender;
- (IBAction)registerButtonClicked:(UIButton *)sender;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wrapView.layer.cornerRadius = 5.f;
    self.wrapView.layer.borderWidth = 1;
    self.wrapView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.11];
    self.wrapView.layer.borderColor = [UIColor colorWithRed:0.67 green:0.7 blue:0.75 alpha:0.20].CGColor;
    
    self.nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 45)];
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 45)];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.emailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 45)];
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.registerButton.layer.cornerRadius = 5.f;
    
    if ([self.nameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.nameTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:16.f]}];
    }
    
    if ([self.passwordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:16.f]}];
    }
    
    if ([self.emailTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.emailTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:16.f]}];
    }
    
    [self.registerButton addTarget:self action:@selector(lowAlfa:) forControlEvents:UIControlEventTouchDown];
    [self.registerButton addTarget:self action:@selector(hightAlfa:)
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideKeyboard {
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}


#pragma mark - Actions

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registerButtonClicked:(UIButton *)sender {
    
    if ([self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] || [self.nameTextField.text isEqualToString:@""]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Ошибка"
                                    message:@"Заполните все поля"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        
    } else {
        
        BOOL isValid = [self validEmail:self.emailTextField.text];
        
        if (!isValid) {
            [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Вы ввели неверный email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            [self.emailTextField becomeFirstResponder];
        } else {
            [self registrationRequest:self.nameTextField.text withPassword:self.passwordTextField.text andEmail:self.emailTextField.text];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == 0 || textField.tag == 2) {
        NSString *myString = string;
        
        NSCharacterSet *illegalChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        
        // Test if there is an illegal character in the string
        BOOL hasIllegalCharacter = [myString rangeOfCharacterFromSet:illegalChars].location != NSNotFound;
        
        BOOL hasLetter = [myString rangeOfCharacterFromSet: [NSCharacterSet letterCharacterSet]].location != NSNotFound;
        
        BOOL hasDigit  = [myString rangeOfCharacterFromSet: [NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
        
        if (!hasDigit  && !hasLetter  && hasIllegalCharacter  ) {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        return (newLength > 20) ? NO : YES;
    }
    else {
        return YES;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    switch (textField.tag) {
        case 0:
            [self.emailTextField becomeFirstResponder];
            break;
        case 1:
            [self.passwordTextField becomeFirstResponder];
            break;
        case 2:
            [textField resignFirstResponder];
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark - Validate Email address

- (BOOL)validEmail:(NSString *)emailString {
    
    if ([emailString length] == 0){
        return NO;
    }
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - API request

- (void)registrationRequest:(NSString*) login withPassword:(NSString*) password andEmail:(NSString *)email {
    
    PFUser *user = [PFUser user];
    user.username = login;
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [[[UIAlertView alloc] initWithTitle:@"Успешно" message:@"Регистрация успешно завершена" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            NSLog(@"Registration error: %@", errorString);
        }
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}


@end
