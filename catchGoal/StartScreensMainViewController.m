//
//  StartScreensMainViewController.m
//  catchGoal
//
//  Created by Oleg Panforov on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "StartScreensMainViewController.h"

@implementation StartScreensMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //hide keyboard on BG tap
    UITapGestureRecognizer *singleTap;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    singleTap.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = TRUE;
    [self.view addGestureRecognizer:singleTap];
}

-(void) viewWillAppear:(BOOL)animated  {
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow: (NSNotification *) notif{
    
    CGFloat height = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.heightOfKeyboard = height;
    self.yNeedToMove = (self.textFieldsView.frame.origin.y + self.textFieldsView.frame.size.height) - (self.view.frame.size.height - self.heightOfKeyboard);
    [self.view layoutIfNeeded];
    
    [self _moveViewByY:-self.yNeedToMove];
}

- (void)keyboardWillHide: (NSNotification *) notif{
    [self _moveViewByY:self.yNeedToMove];
}

- (void)_moveViewByY:(CGFloat)dy {
    NSTimeInterval animationDuration = 0.2f;
    [self _moveView:self.textFieldsView byY:dy withAnimationDuration:animationDuration];
}

- (void)_moveView:(UIView *)view byY:(CGFloat)dy withAnimationDuration:(NSTimeInterval)duration {
    __block UIView *blockSafeView = view;
    
    [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        blockSafeView.frame = CGRectOffset(blockSafeView.frame, 0, dy);
    } completion:nil];
}


@end
