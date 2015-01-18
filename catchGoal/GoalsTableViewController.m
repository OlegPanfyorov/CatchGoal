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

@property (assign, nonatomic) float progress;

- (IBAction)logOutPressed:(UIBarButtonItem *)sender;

@end

@implementation GoalsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    [self performSelector:@selector(generateNewCell) withObject:nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)generateNewCell {
    
    self.goalsArray = [NSMutableArray array];
    Goal *goal = [Goal new];
    goal.name = @"IPhone 6 Plus";
    goal.price = @100;
    goal.progress = @70;
    // Total accumulated
    CGFloat intProgress = [goal.progress floatValue];
    CGFloat intPrice = [goal.price floatValue];
    self.progress = (float) intProgress / 100;

    self.progress = (float)((intProgress * 100 / intPrice) / 100);
    
    for (int i = 0; i < 5; i++) {
        [self.goalsArray addObject:goal];
    }
    
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
    cell.lineProgressView.progress = self.progress;
    
    return cell;
}

- (IBAction)logOutPressed:(UIBarButtonItem *)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PFUser logOut];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    });
    
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
