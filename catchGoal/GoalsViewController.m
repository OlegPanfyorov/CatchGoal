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

@interface GoalsViewController () <UITableViewDelegate, UITableViewDataSource>
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
    
    return cell;
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
