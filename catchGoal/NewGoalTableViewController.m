//
//  NewGoalTableViewController.m
//  catchGoal
//
//  Created by Brusnikin on 1/18/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#define kNavBarColorBlue [UIColor colorWithRed:0.32 green:0.64 blue:0.9 alpha:1]
#define kNavBarColorGreen [UIColor colorWithRed:0.52 green:0.98 blue:0.49 alpha:1]

#import "NewGoalTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "RMDateSelectionViewController.h"
#import "UIActionSheet+BlockExtensions.h"

static NSInteger const kNavAndStatusBarHeight = 64;

@interface NewGoalTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

{
    DataSingletone *singletone;
}

@property (weak, nonatomic) IBOutlet UITextField *goalName;
@property (weak, nonatomic) IBOutlet UITextField *totalCost;
@property (weak, nonatomic) IBOutlet UITextField *progressInMoney;
@property (weak, nonatomic) IBOutlet UITextField *finalDateTextField;
@property (weak, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (strong, nonatomic) GoalOperations* operations;
@property (strong, nonatomic) NSDate *finalDate;
@property (strong, nonatomic) NSString *imagePath;

- (IBAction)choosePhotoButtonClicked:(id)sender;

@end

@implementation NewGoalTableViewController
@synthesize goalName, totalCost;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.choosePhotoButton.alpha = 0.75;
    
    NSLog(@"Navframe Height=%f",
          self.navigationController.navigationBar.frame.size.height + 20);
    UIButton* saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton addTarget:self action:@selector(addNewGoal) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = CGRectMake(0, self.view.frame.size.height - kNavAndStatusBarHeight * 2, self.view.frame.size.width, kNavAndStatusBarHeight);
    saveButton.backgroundColor = [[UIColor colorWithRed:0.32 green:0.64 blue:0.9 alpha:1] colorWithAlphaComponent:0.3];
    [saveButton setTitle:@"Сохранить" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:saveButton];
    self.tableView.alwaysBounceVertical = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        
    UIBarButtonItem *cancelItem =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:self
                                                 action:@selector(cancelToBack)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //show datapicker
    UITapGestureRecognizer *singleTap;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(showDatePicker)];
    singleTap.numberOfTapsRequired = 1;
    [self.finalDateTextField addGestureRecognizer:singleTap];
    
    //hide keyboard on BG tap
    UITapGestureRecognizer *hideKeyboard;
    hideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(hideKeyboard)];
    hideKeyboard.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = TRUE;
    [self.view addGestureRecognizer:hideKeyboard];
    
    self.choosePhotoButton.layer.cornerRadius = self.choosePhotoButton.frame.size.height / 2;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"interior-blur.png"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.tableView setBackgroundView:imageView];
}

- (void)hideKeyboard {
    [self.goalName resignFirstResponder];
    [self.totalCost resignFirstResponder];
    [self.progressInMoney resignFirstResponder];
    [self.finalDateTextField resignFirstResponder];
}

-(void) showDatePicker {
    [self hideKeyboard];
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.hideNowButton = YES;
    
    //You can enable or disable bouncing and motion effects
    dateSelectionVC.disableBouncingWhenShowing = YES;
    dateSelectionVC.disableMotionEffects = YES;
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionVC.datePicker.minuteInterval = 5;
    NSDate *datePlusMonth = [NSDate date];
    datePlusMonth = [datePlusMonth dateByAddingTimeInterval:(30 * 24 * 60 * 60)];
    [dateSelectionVC.datePicker setMinimumDate:[NSDate date]];
    dateSelectionVC.datePicker.date = datePlusMonth;

    [dateSelectionVC showWithSelectionHandler:^(RMDateSelectionViewController *vc, NSDate *aDate) {
        NSLog(@"Successfully selected date: %@ (With block)", aDate);
        self.finalDate = aDate;
        self.finalDateTextField.text = [self convertDateToString:aDate];
    } andCancelHandler:^(RMDateSelectionViewController *vc) {
        NSLog(@"Date selection was canceled (with block)");
        self.finalDate = datePlusMonth;
        self.finalDateTextField.text = [self convertDateToString:datePlusMonth];
    }];
}

-(NSString*) convertDateToString:(NSDate*) date {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM, yyyy"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    format.locale = usLocale;
    NSString *theDate = [format stringFromDate:date];
    NSLog(@"%@", date);
    return theDate;
}

-(NSNumber*) convertStringToNSNumber:(NSString*) string {
    NSNumberFormatter *number = [[NSNumberFormatter alloc] init];
    number.numberStyle = NSNumberFormatterDecimalStyle;
    return [number numberFromString:string];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    switch (textField.tag) {
        case 0:
            [self.totalCost becomeFirstResponder];
            break;
        case 1:
            [self.progressInMoney becomeFirstResponder];
            break;
        case 2:
            [self.progressInMoney resignFirstResponder];
            //[self.finalDateTextField becomeFirstResponder];
            break;
        case 3:
            //[textField resignFirstResponder];
            break;
        default:
            break;
    }
    //[textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 3) {
        [self showDatePicker];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.tag == 1 || textField.tag == 2) {
        NSString *formatedText = [self formatText:textField.text];
        textField.text = formatedText;
    }
    return YES;
}

#pragma mark - Actions

-(void)addNewGoal {
    if (!self.finalDate || [self.goalName.text isEqualToString:@""] || [self.totalCost.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Заполните все поля" delegate:nil cancelButtonTitle:@"Ок" otherButtonTitles: nil] show];
    } else {
        if ([self.progressInMoney.text isEqualToString:@""]) {
            self.progressInMoney.text = @"0";
        }
        if ([self.progressInMoney.text integerValue] >= [self.totalCost.text integerValue]) {
            [[[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Текущие накопления не могут превышать стоимость цели" delegate:nil cancelButtonTitle:@"Ок" otherButtonTitles: nil] show];
        } else {
            self.goal = [Goal createEntity];
            self.goal.name = self.goalName.text;
            self.goal.price = [self convertStringToNSNumber:self.totalCost.text];
            self.goal.progress = [self convertStringToNSNumber:self.progressInMoney.text];
            self.goal.startDate = [NSDate date];
            self.goal.finalDate = self.finalDate;
            self.goal.imagePath = self.imagePath;
            self.goal.complited = [NSNumber numberWithBool:NO];
            if (self.goal.progress.integerValue > 0) {
                self.operations = [GoalOperations createEntity];
                self.operations.addSum = self.goal.progress;
                self.operations.addDate = [NSDate date];
                [self.goal addOperationsObject:self.operations];
            }
            [[DataSingletone sharedModel].goalsArray addObject:self.goal];
            [[DataSingletone sharedModel] saveContext];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(NSString*) formatText:(NSString*) string {
    
    if (string != nil) {
        NSString *numberBeta = string;
        NSString *numberThreeEight = [[numberBeta componentsSeparatedByCharactersInSet:
                                       [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                      componentsJoinedByString:@""];
        return numberThreeEight;
    }
    else {
        return @"";
    }
}

- (void)setImageForGoal:(UIImage*)image {
    self.choosePhotoButton.imageView.image = image;
}

-(void)cancelToBack {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)choosePhotoButtonClicked:(id)sender {
    [self showActionSheetToChooseSourceAndMakeImagePickerWithEditing:YES];
}

#pragma mark - UITableView


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePicker

- (void)showActionSheetToChooseSourceAndMakeImagePickerWithEditing:(BOOL)edited {
    UIActionSheet *sheet = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil
                                     completionBlock:
                 ^(NSUInteger buttonIndex, UIActionSheet *actionSheet) {
                     UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                     imgPicker.allowsEditing = edited;
                     [imgPicker setDelegate:(id)self];
                     
                     switch (buttonIndex) {
                         case 0:
                             imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                             [self presentViewController:imgPicker animated:YES completion:nil];
                             break;
                             
                         case 1:
                             imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                             [self presentViewController:imgPicker animated:YES completion:nil];
                             break;
                         case 2:
                             [self deletePhoto];
                             break;
                             
                         default:
                             break;
                     }
                 }
                                   cancelButtonTitle:@"Отмена"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"Камера",@"Галерея", @"Удалить", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil
                                     completionBlock:
                 ^(NSUInteger buttonIndex, UIActionSheet *actionSheet) {
                     UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                     imgPicker.allowsEditing = YES;
                     [imgPicker setDelegate:(id)self];
                     
                     switch (buttonIndex) {
                         case 0:
                             imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                             [self presentViewController:imgPicker animated:YES completion:nil];
                             break;
                         case 1:
                             [self deletePhoto];
                             break;
                         default:
                             break;
                     }
                 }
                                   cancelButtonTitle:@"Отмена"
                              destructiveButtonTitle:nil
                                   otherButtonTitles:@"Галерея", @"Удалить", nil];
    }
    
    [sheet showInView:self.view];
}

#pragma mark - UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *imgData   = UIImageJPEGRepresentation(image, 0.5);
    NSString *name    = [[NSUUID UUID] UUIDString];
    NSString *path	  = [NSString stringWithFormat:@"Documents/%@.jpg", name];
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    [imgData writeToFile:jpgPath atomically:YES];
    self.imagePath = path;
    [self setGoalButtonImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) deletePhoto {
    [self setGoalButtonImage:[UIImage imageNamed:@"no_photo"]];
    self.imagePath = NULL;
}

-(void) setGoalButtonImage:(UIImage*) image {
    [self.choosePhotoButton setImage:image forState:UIControlStateNormal];
    [self.choosePhotoButton setImage:image forState:UIControlStateHighlighted];
    self.choosePhotoButton.layer.cornerRadius = self.choosePhotoButton.frame.size.height / 2;
}

@end
