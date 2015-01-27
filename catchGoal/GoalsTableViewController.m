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

@property (assign, nonatomic) CGFloat progress;


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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)generateNewCell {

    for (int i = 0; i < 5; i++) {
        Goal *goal = [Goal new];
        int iPhoneNumber = arc4random() % 4 + 2;
        int totalPrice = (arc4random() % 10 + 1) * 1000;
        int progress = (arc4random() % 5 + 1) * 200;
        goal.name = [NSString stringWithFormat:@"iPhone %d", iPhoneNumber];
        goal.price = [NSNumber numberWithInt:totalPrice];
        goal.perMonth = @100;
        goal.progress = [NSNumber numberWithInt:progress];
        
        self.progress = (float)([goal.progress floatValue] * 100 / [goal.price floatValue]);
        
        [[DataSingletone sharedModel].goalsArray addObject:goal];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [[DataSingletone sharedModel].goalsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    GoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    Goal *goal = [DataSingletone sharedModel].goalsArray[indexPath.row];
    cell.nameLabel.text = goal.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", goal.price];
    cell.progressLabel.text = [NSString stringWithFormat:@"%0.f%%", self.progress];
    cell.lineProgressView.progress = (float)([goal.progress floatValue] * 100 / [goal.price floatValue]) / 100;
    
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
        detailTableViewController.selectedItemInArray = indexPath.row;
        detailTableViewController.goalsArray = [DataSingletone sharedModel].goalsArray;
        
        Goal *goal = [DataSingletone sharedModel].goalsArray[indexPath.row];
        detailTableViewController.nameLabel.text = goal.name;
        detailTableViewController.priceLabel.text = [NSString stringWithFormat:@"$%@", goal.price];
        detailTableViewController.perMonthLabel.text = [NSString stringWithFormat:@"$%@", goal.perMonth];
        detailTableViewController.totalLabel.text = [NSString stringWithFormat:@"%@", goal.progress];
        detailTableViewController.progress = self.progress;
        
        NSLog(@"0.%f", self.progress);
    }
    
}

@end
