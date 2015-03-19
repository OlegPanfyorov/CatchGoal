//
//  GoalsViewController.m
//  catchGoal
//
//  Created by user on 2/28/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "GoalsViewController.h"
#import "DetailViewController.h"
#import "GoalTableViewCell.h"
#import "SWRevealTableViewCell.h"

@interface GoalsViewController () <UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDelegate, SWRevealTableViewCellDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) CGFloat progress;
@property (strong, nonatomic) NSIndexPath* indexPath;
@property (strong, nonatomic) GoalOperations* operations;
@property (assign, nonatomic) NSInteger operationsSum;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *buttonIndicators;

- (IBAction)logOutPressed:(UIBarButtonItem *)sender;
@end

@implementation GoalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    UIEdgeInsets inset = {-14,0,-31,0};
    self.tableView.contentInset = inset;
    [self.navigationController.navigationBar setHidden:NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.tableView.alwaysBounceVertical = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-main.png"]];
    imageView.frame = [UIScreen mainScreen].bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self.view insertSubview:imageView belowSubview:self.tableView];
    [self.view sendSubviewToBack:imageView];
    
    self.buttonView.backgroundColor = [[UIColor colorWithRed:0.13 green:0.13 blue:0.16 alpha:1] colorWithAlphaComponent:0.55];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchGoalsWithCompletedFlag:NO];

   // [[DataSingletone sharedModel] saveToParse];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [[DataSingletone sharedModel].goalsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    GoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell.lineProgressView setProgress:0];
    Goal *goal = [[DataSingletone sharedModel].goalsArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = goal.name;
    cell.nameLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ %@ собрано", goal.progress, CURRENCY_SYMBOL];
    cell.priceLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    cell.delegate = self;
    cell.dataSource = self;
    cell.cellRevealMode = SWCellRevealModeNormal;
    
    
    NSData *goalImage = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:goal.imagePath]];
    
    if (goal.imagePath) {
        cell.image.image = [UIImage imageWithData:goalImage];
    } else {
        cell.image.image = [UIImage imageNamed:@"no_photo"];
    }
    
    CGFloat progress = [goal.progress floatValue] / [goal.price floatValue];
    [cell.lineProgressView setProgress:progress timing:TPPropertyAnimationTimingEaseOut duration:1.0 delay:0.5];
    
    if (progress < 0.5f) {
        [cell.lineProgressView setColorTable: @{
                                                NSStringFromProgressLabelColorTableKey(ProgressLabelFillColor):
                                                    [UIColor colorWithWhite:1.0 alpha:0.15],
                                                NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                                    [UIColor colorWithRed:1 green:0.39 blue:0.33 alpha:1],
                                                }];
    } else {
        [cell.lineProgressView setColorTable: @{
                                                NSStringFromProgressLabelColorTableKey(ProgressLabelFillColor):
                                                    [UIColor colorWithWhite:1.0 alpha:0.15],
                                                NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                                    [UIColor colorWithRed:0.42 green:0.82 blue:0.28 alpha:1],
                                                }];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - SWRevealTableViewCell delegate

- (void)revealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell willMoveToPosition:(SWCellRevealPosition)position
{
    if ( position == SWCellRevealPositionCenter )
        return;
    
    for ( SWRevealTableViewCell *cell in [self.tableView visibleCells] )
    {
        if ( cell == revealTableViewCell )
            continue;
        
        [cell setRevealPosition:SWCellRevealPositionCenter animated:YES];
    }
}


- (void)revealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell didMoveToPosition:(SWCellRevealPosition)position
{
}

- (NSArray*)rightButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell
{
    NSArray *items = nil;
    
    SWCellButtonItem *item1 = [SWCellButtonItem itemWithImage:[UIImage imageNamed:@"done.png"] handler:^(SWCellButtonItem *item, SWRevealTableViewCell *cell)
                               {
                                   self.indexPath = [self.tableView indexPathForCell:cell];
                                   Goal* goal = [[DataSingletone sharedModel].goalsArray objectAtIndex:self.indexPath.row];
                                   int sumLeft = [goal.price intValue] - [goal.progress intValue];
                                   goal.progress = [NSNumber numberWithInt:sumLeft + [goal.progress intValue]];
                                   goal.complited = [NSNumber numberWithBool:YES];
                                   self.operations = [GoalOperations createEntity];
                                   self.operations.addSum = [NSNumber numberWithInt: sumLeft];
                                   self.operations.addDate = [NSDate date];
                                   [goal addOperationsObject:self.operations];
                                   [[DataSingletone sharedModel].goalsArray removeObjectAtIndex:self.indexPath.row];
                                   [[DataSingletone sharedModel] saveContext];
                                   [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                   NSLog( @"Heart Tapped %d", sumLeft);
                                   return YES;
                               }];
    
    item1.backgroundColor = [UIColor colorWithRed:0.079 green:0.402 blue:0.000 alpha:0.480];
    item1.tintColor = [UIColor whiteColor];
    item1.width = 70;
    
    SWCellButtonItem *item2 = [SWCellButtonItem itemWithImage:[UIImage imageNamed:@"edit.png"] handler:^(SWCellButtonItem *item, SWRevealTableViewCell *cell)
                               {
                                   NSLog( @"EDIT Tapped");
                                   self.indexPath = [self.tableView indexPathForCell:cell];
                                   Goal* goal = [[DataSingletone sharedModel].goalsArray objectAtIndex:self.indexPath.row];

                                   UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:goal.name
                                                                                            delegate:self
                                                                                   cancelButtonTitle:@"Отмена"
                                                                              destructiveButtonTitle:nil
                                                                                   otherButtonTitles:@"Изменить фото", @"Изменить название", @"Изменить стоимость", nil];
                                   [actionSheet showInView:self.view];
                                   return YES;
                               }];
    
    item2.backgroundColor = [UIColor colorWithRed:0.208 green:0.584 blue:0.886 alpha:0.500]; //[UIColor darkGrayColor];
    item2.tintColor = [UIColor whiteColor];
    item2.width = 70;
    
    SWCellButtonItem *item3 = [SWCellButtonItem itemWithImage:[UIImage imageNamed:@"delete.png"] handler:^(SWCellButtonItem *item, SWRevealTableViewCell *cell)
                               {
                                   self.indexPath = [self.tableView indexPathForCell:cell];
                                   Goal* goal = [[DataSingletone sharedModel].goalsArray objectAtIndex:self.indexPath.row];
                                   
                                   if (goal.imagePath) {
                                       NSError *error;
                                       NSString *imgToRemove = [NSHomeDirectory() stringByAppendingPathComponent:goal.imagePath];
                                       [[NSFileManager defaultManager] removeItemAtPath:imgToRemove error:&error];
                                       NSLog( @"Image has been deteted at Path - %@", goal.imagePath);
                                   }
                                   
                                   [goal deleteEntity];
                                   [[DataSingletone sharedModel] saveContext];
                                   [[DataSingletone sharedModel].goalsArray removeObjectAtIndex:self.indexPath.row];
                                   [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                   return YES;
                               }];
    
    item3.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.080 alpha:0.420]; //[UIColor lightGrayColor];
    item3.tintColor = [UIColor whiteColor];
    item3.width = 70;
    
    items = @[item1,item2,item3];

    
    NSLog( @"Providing right Items");
    return items;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    Goal* goal = [[DataSingletone sharedModel].goalsArray objectAtIndex:self.indexPath.row];
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;

    switch (buttonIndex) {
        case 0: {
            NSLog(@"Edit PHOTO clicked");
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.showAnimationType = SlideInFromTop;
            alert.backgroundType = Shadow;
            
            UIColor *color = [UIColor colorWithRed:53.0/255.0 green:149.0/255.0 blue:226.0/255.0 alpha:1.0];
            [alert addButton:@"Камера" actionBlock:^{
                UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                imgPicker.allowsEditing = YES;
                [imgPicker setDelegate:self];
                imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imgPicker animated:YES completion:nil];
            }];
            [alert addButton:@"Галерея" actionBlock:^{
                UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                imgPicker.allowsEditing = YES;
                [imgPicker setDelegate:self];
                imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imgPicker animated:YES completion:nil];
            }];
            [alert showCustom:self image:[UIImage imageNamed:@"logoAlert"] color:color title:@"Выберите источник:" subTitle:nil closeButtonTitle:@"Отмена" duration:0.0f];
        }
            break;
        case 1: {
            NSLog(@"Edit NAME clicked");
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.showAnimationType = SlideInFromTop;
            alert.backgroundType = Shadow;
            
            UITextField *textField = [alert addTextField:@"Новое название"];
            // [textField becomeFirstResponder];
            
            [alert addButton:@"Готово" actionBlock:^(void) {
                if (![textField.text isEqualToString:@""]) {
                    NSString *newName = textField.text;
                    goal.name = newName;
                    [[DataSingletone sharedModel] saveContext];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.37 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationLeft];

                    });   //Меняем название в базе
                }
            }];
            
            [alert addButton:@"Отмена" actionBlock:^(void) {
            }];
            
            [alert showInfo:self title:@"Изменить название?"
                      subTitle:[NSString stringWithFormat:@"Текущее название: %@", goal.name]
              closeButtonTitle:nil duration:0.0f];
        }
            break;
        case 2: {
            NSLog(@"Edit PRICE clicked");
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.showAnimationType = SlideInFromTop;
            alert.backgroundType = Shadow;
            
            UITextField *textField = [alert addTextField:@"Новая стоимость"];
            // [textField becomeFirstResponder];
            
            self.operationsSum = 0;
            for (GoalOperations *operation in goal.operations) {
                self.operationsSum = self.operationsSum + operation.addSum.integerValue;
            }
            NSLog(@"operations sum of goal: %@ is %zd", goal.name, self.operationsSum);
            
            [alert addButton:@"Готово" actionBlock:^(void) {
                NSString *newPrice = [self formatText:textField.text];
                    if (![newPrice isEqualToString:@""] && [newPrice integerValue] <= self.operationsSum) {
                        
                        SCLAlertView *infoAler = [[SCLAlertView alloc] init];
                        infoAler.backgroundType = Shadow;
                        [infoAler addButton:@"Завершить" actionBlock:^{
                            goal.price = [formatter numberFromString:newPrice];
                            goal.progress = [formatter numberFromString:newPrice];
                            goal.complited = [NSNumber numberWithBool:YES];
                            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                                [self fetchGoalsWithCompletedFlag:NO];
                            }];

                        }];
                        //[self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        NSString *messageString = [NSString stringWithFormat:@"Введенная сумма меньше или равна собранным на %@ накоплениям! Хотите завершить данную цель?", goal.name];
                        [infoAler showInfo:self title:@"Внимание" subTitle:messageString closeButtonTitle:@"Отмена" duration:0];
                    } else if ([newPrice integerValue] > self.operationsSum) {
                        goal.price = [formatter numberFromString:newPrice];
                        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                            [self fetchGoalsWithCompletedFlag:NO];
                        }];
                    }
            }];
            
            [alert addButton:@"Отмена" actionBlock:^(void) {
                
            }];
            
            [alert showInfo:self title:@"Изменить стоимость?"
                   subTitle:[NSString stringWithFormat:@"Текущая стоимость: %@ %@\nТекущие накопления: %d %@", goal.price, CURRENCY_SYMBOL, self.operationsSum, CURRENCY_SYMBOL]
           closeButtonTitle:nil duration:0.0f];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    Goal* goal = [[DataSingletone sharedModel].goalsArray objectAtIndex:self.indexPath.row];
    
    if (goal.imagePath) {
        NSError *error;
        NSString *imgToRemove = [NSHomeDirectory() stringByAppendingPathComponent:goal.imagePath];
        [[NSFileManager defaultManager] removeItemAtPath:imgToRemove error:&error];
        NSLog( @"Image has been deteted at Path - %@", goal.imagePath);
    }

    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *imgData   = UIImageJPEGRepresentation(image, 0.5);
    NSString *name    = [[NSUUID UUID] UUIDString];
    NSString *path	  = [NSString stringWithFormat:@"Documents/%@.jpg", name];
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    [imgData writeToFile:jpgPath atomically:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        goal.imagePath = path;
        [[DataSingletone sharedModel] saveContext];
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }];
}

-(NSString*) formatText:(NSString*) string {
    if (string != nil) {
        NSString *numberBeta = string;
        NSString *numberThreeEight = [[numberBeta componentsSeparatedByCharactersInSet:
                                       [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                      componentsJoinedByString:@""];
        return numberThreeEight;
    } else {
        return @"";
    }
}

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [self logOut];
            break;

        default:
            break;
    }
}

#pragma mark - Actions

- (IBAction)logOutPressed:(UIBarButtonItem *)sender {
    [[[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Вы уверены что хотите выйти?" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Да", nil] show];
}

- (void) logOut {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PFUser logOut];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    });
}

- (void) fetchGoalsWithCompletedFlag:(BOOL) isCompleted {
    [DataSingletone sharedModel].goalsArray = [NSMutableArray new];
    if (isCompleted) {
        NSPredicate *isCompleted = [NSPredicate predicateWithFormat:@"complited == YES"];
        [DataSingletone sharedModel].goalsArray = [NSMutableArray arrayWithArray:[Goal findAllWithPredicate:isCompleted]];
        [self.tableView reloadData];
    } else {
        NSPredicate *isCompleted = [NSPredicate predicateWithFormat:@"complited == NO"];
        [DataSingletone sharedModel].goalsArray = [NSMutableArray arrayWithArray:[Goal findAllWithPredicate:isCompleted]];
        [self.tableView reloadData];
    }

}

- (IBAction)allGoalsPressed:(UIButton*)sender {
    [self fetchGoalsWithCompletedFlag:NO];
    
    [[self.buttonIndicators firstObject] setBackgroundColor:[UIColor colorWithRed:1 green:0.39 blue:0.33 alpha:1]];
    [[self.buttonIndicators lastObject] setBackgroundColor:[UIColor clearColor]];

    

}
- (IBAction)complitedGoalsPressed:(UIButton*)sender {
    [self fetchGoalsWithCompletedFlag:YES];
    
    [[self.buttonIndicators firstObject] setBackgroundColor:[UIColor clearColor]];
    [[self.buttonIndicators lastObject] setBackgroundColor:[UIColor colorWithRed:0.42 green:0.82 blue:0.28 alpha:0.75]];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDetailSegue"]) {
        DetailViewController *detailTableViewController = (DetailViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailTableViewController.selectedItemInArray = indexPath.row;
    }
}

@end
