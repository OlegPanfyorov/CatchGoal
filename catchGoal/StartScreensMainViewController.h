//
//  StartScreensMainViewController.h
//  catchGoal
//
//  Created by Oleg Panforov on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartScreensMainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView* textFieldsView;
@property (assign, nonatomic) CGFloat heightOfKeyboard;
@property (assign, nonatomic) CGFloat yNeedToMove;

- (void)keyboardWillShow: (NSNotification *) notif;
- (void)keyboardWillHide: (NSNotification *) notif;

- (void)showHUD;
- (void)hideHUD;

@end
