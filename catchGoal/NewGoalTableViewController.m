//
//  NewGoalTableViewController.m
//  catchGoal
//
//  Created by Brusnikin on 1/18/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "NewGoalTableViewController.h"
#import "BGDatePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface NewGoalTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    DataSingletone *singletone;
}

@property (weak, nonatomic) IBOutlet UITextField *goalName;


//////////////// Old Property

@property (strong, nonatomic) BGDatePicker *datePicker;
@property (strong, nonatomic) UIBarButtonItem *cameraItem;

//@property (weak, nonatomic) IBOutlet UITextField *goalName;
@property (weak, nonatomic) IBOutlet UITextField *totalCost;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDeadline;
@property (weak, nonatomic) IBOutlet UITextView *commentView;
@property (weak, nonatomic) IBOutlet UIImageView *picture;

@end

@implementation NewGoalTableViewController
@synthesize datePicker, textFieldDeadline, cameraItem, picture, goalName, totalCost, commentView;

- (void)viewDidLoad {
    [super viewDidLoad];
    


    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.98 blue:0.99 alpha:1];

    
    singletone = [DataSingletone sharedModel];
        
    datePicker =
    [[BGDatePicker alloc]initWithDateFormatString:@"dd.MM.yyyy"
                                     forTextField:textFieldDeadline
                               withDatePickerMode:UIDatePickerModeDateAndTime];
    
    datePicker.date = [NSDate date];
    
    textFieldDeadline.inputView = datePicker;
    textFieldDeadline.inputAccessoryView = datePicker.toolbar;
    
    UIBarButtonItem *cancelItem =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:self
                                                 action:@selector(cancelToBack)];
    
    UIBarButtonItem *saveItem =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                 target:self
                                                 action:@selector(addNewGoal)];
    
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)addNewGoal {
    
    NSLog(@"New Goal was created");
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelToBack {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView




-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd.MM.yyyy";
    
    switch (section) {
        case 0:
            return title =
            [NSString stringWithFormat:@"Старт: %@",
             [dateFormatter stringFromDate:[NSDate date]]];
            break;
        case 1:
            return title = @"Комментарий";
            break;
        case 2:
            return title = @"Фотография";
            break;
        default:
            break;
    }
    
    return title;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    cameraItem =
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                 target:self
                                                 action:@selector(choosePictureFromAlbumDevice)];
    
    UIToolbar *smallToolbar =
    [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.sectionFooterHeight, self.tableView.frame.size.width)];
    
    smallToolbar.items = [NSArray arrayWithObjects:cameraItem, nil];
    
    return section == 2 ? smallToolbar : nil;
}


-(void)choosePictureFromAlbumDevice {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *imagePicker =
        [UIImagePickerController new];
        
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, nil];
        
        imagePicker.allowsEditing = NO;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        picture.image = image;
    }
    
    NSArray *newGoalInfo = [NSArray arrayWithObjects: goalName, totalCost, commentView, picture, nil];
    
    [singletone.goalsArray addObjectsFromArray:newGoalInfo];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
 
    return 16.0;
}
*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
