//
//  ForgotPasswordViewController.m
//  catchGoal
//
//  Created by Oleg Panforov on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;

- (IBAction)backButtonPressed:(UIButton *)sender;
- (IBAction)restorePasswordPressed:(UIButton *)sender;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.restoreButton.layer.cornerRadius = 5.f;
    self.emailTextField.layer.cornerRadius = 5.f;
    
    if ([self.emailTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.emailTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:18.f]}];
    }
    
    [self.restoreButton addTarget:self action:@selector(lowAlfa:) forControlEvents:UIControlEventTouchDown];
    [self.restoreButton addTarget:self action:@selector(hightAlfa:)
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

-(void) hideKeyboard {
    [self.emailTextField resignFirstResponder];
}

#pragma mark - Actions

- (IBAction)restorePasswordPressed:(UIButton *)sender {
    
    if ([self.emailTextField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Заполните все поля" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    } else {
        
        BOOL isValid = [self validEmail:self.emailTextField.text];
        
        if (!isValid) {
            [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Вы ввели неверный email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            [self.emailTextField becomeFirstResponder];
        } else {
            [self forgotPasswordRequest:self.emailTextField.text];
        }
    }
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Validate Email address

- (BOOL)validEmail:(NSString *)emailString {
    
    if([emailString length]==0){
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


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - API Request

- (void)forgotPasswordRequest:(NSString *)email {
    [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[[UIAlertView alloc] initWithTitle:@"Успешно"
                                        message:@"На ваш email адресс отправлена ссылка по котороый вы можете изменить пароль"
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
            
        } else {
            NSLog(@"Forgot password request error: %@", [error description]);
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
