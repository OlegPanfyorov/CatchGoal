//
//  GoalsTableViewController.m
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "GoalsTableViewController.h"
#import "DetailTableViewController.h"
#import "GoalTableViewCell.h"
#import "Goal.h"

@interface GoalsTableViewController ()

- (IBAction)logOutPressed:(UIBarButtonItem *)sender;

@end

@implementation GoalsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Delete separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.navigationController.navigationBarHidden = NO;
    [self performSelector:@selector(generateNewCell) withObject:nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)generateNewCell {
    
    self.goalsArray = [NSMutableArray array];
    Goal *goal = [Goal new];
    goal.name = @"Name of the goal";
    goal.price = @100;
    goal.progress = @0;
    [self.goalsArray addObject:goal];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.goalsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    GoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    Goal *goal = self.goalsArray[indexPath.row];
    cell.nameLabel.text = goal.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", goal.price];
    cell.progressLabel.text = [NSString stringWithFormat:@"%@%%", goal.progress];
    
    return cell;
}

- (IBAction)logOutPressed:(UIBarButtonItem *)sender {
    
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDetailSegue"]) {
        
        DetailTableViewController *detailTableViewController = (DetailTableViewController *)segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Goal *goal = self.goalsArray[indexPath.row];
        detailTableViewController.nameLabel.text = goal.name;
        detailTableViewController.priceLabel.text = [NSString stringWithFormat:@"$%@", goal.price];
        detailTableViewController.perMonthLabel.text = [NSString stringWithFormat:@"$%@", goal.perMonth];
        detailTableViewController.totalLabel.text = [NSString stringWithFormat:@"%@", goal.progress];
    }
    
}

@end
