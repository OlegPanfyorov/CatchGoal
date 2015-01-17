//
//  GoalsTableViewController.m
//  catchGoal
//
//  Created by Maverick on 1/17/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "GoalsTableViewController.h"
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
    
    [self performSelector:@selector(generateNewCell) withObject:nil];
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
}
@end
