//
//  GoalsViewController.m
//  catchGoal
//
//  Created by user on 2/28/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "GoalsViewController.h"
#import "DetailTableViewController.h"
#import "GoalTableViewCell.h"
#import "Goal.h"
#import "SWRevealTableViewCell.h"

@interface GoalsViewController () <UITableViewDelegate, UITableViewDataSource,SWRevealTableViewCellDelegate, SWRevealTableViewCellDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) CGFloat progress;

- (IBAction)logOutPressed:(UIBarButtonItem *)sender;
@end

@implementation GoalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIEdgeInsets inset = {1,0,10,0};
    self.tableView.contentInset = inset;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [self.navigationController.navigationBar setHidden:NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tableView.alwaysBounceVertical = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"interior.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.tableView setBackgroundView:imageView];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchGoalsWithCompletedFlag:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [[DataSingletone sharedModel].goalsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    GoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell.lineProgressView setProgress:0];
    Goal *goal = [[DataSingletone sharedModel].goalsArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = goal.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ собрано", goal.progress];
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
                                                    [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1],
                                                NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                                    [UIColor colorWithRed:1 green:0.39 blue:0.33 alpha:1],
                                                }];
    } else {
        [cell.lineProgressView setColorTable: @{
                                                NSStringFromProgressLabelColorTableKey(ProgressLabelFillColor):
                                                    [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1],
                                                NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                                    [UIColor colorWithRed:0.42 green:0.82 blue:0.28 alpha:1],
                                                }];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // customize here the cell object before it is displayed.

    [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
    //[cell.contentView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1]];

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
                                   NSLog( @"Star Tapped");
                                   return YES;
                               }];
    
    item1.backgroundColor = [UIColor colorWithRed:0.079 green:0.402 blue:0.000 alpha:0.480];
    item1.tintColor = [UIColor whiteColor];
    item1.width = 70;
    
    SWCellButtonItem *item2 = [SWCellButtonItem itemWithImage:[UIImage imageNamed:@"edit.png"] handler:^(SWCellButtonItem *item, SWRevealTableViewCell *cell)
                               {
                                   NSLog( @"Heart Tapped");
                                   return YES;
                               }];
    
    item2.backgroundColor = [UIColor colorWithRed:0.208 green:0.584 blue:0.886 alpha:0.500]; //[UIColor darkGrayColor];
    item2.tintColor = [UIColor whiteColor];
    item2.width = 70;
    
    SWCellButtonItem *item3 = [SWCellButtonItem itemWithImage:[UIImage imageNamed:@"delete.png"] handler:^(SWCellButtonItem *item, SWRevealTableViewCell *cell)
                               {
                                   NSLog( @"Airplane Tapped");
                                   return YES;
                               }];
    
    item3.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.080 alpha:0.420]; //[UIColor lightGrayColor];
    item3.tintColor = [UIColor whiteColor];
    item3.width = 70;
    
    items = @[item1,item2,item3];

    
    NSLog( @"Providing right Items");
    return items;
}


#pragma mark - Actions

- (IBAction)logOutPressed:(UIBarButtonItem *)sender {
    
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

}
- (IBAction)complitedGoalsPressed:(UIButton*)sender {
    [self fetchGoalsWithCompletedFlag:YES];

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDetailSegue"]) {
        DetailTableViewController *detailTableViewController = (DetailTableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailTableViewController.selectedItemInArray = indexPath.row;
    }
}

@end
