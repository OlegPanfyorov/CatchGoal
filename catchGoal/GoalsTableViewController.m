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
    
    [self generateNewCell];
    
    UIEdgeInsets inset = {1,0,10,0};
    
    self.tableView.contentInset = inset;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    self.navigationController.navigationBarHidden = NO;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self generateNewCell]; 
}

-(void) viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)generateNewCell {
    
    [DataSingletone sharedModel].goalsArray = [NSMutableArray new];
    

    for (int i = 0; i < 15; i++) {
        
        Goal *goal = [Goal new];

        int iPhoneNumber = arc4random() % 4 + 2;
        int totalPrice = (arc4random() % 10 + 1) * 1000;
        int progress = arc4random_uniform(101);
        goal.name = [NSString stringWithFormat:@"iPhone %d", iPhoneNumber];

        goal.price = [NSNumber numberWithInt:totalPrice];
        goal.perMonth = @100;
        goal.progress = [NSNumber numberWithInt:progress];
        
        [[DataSingletone sharedModel].goalsArray addObject:goal];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%zd", [[DataSingletone sharedModel].goalsArray count]);
    
    return  [[DataSingletone sharedModel].goalsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *identifier = @"cell";
    GoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell.lineProgressView setProgress:0];
    Goal *goal = [DataSingletone sharedModel].goalsArray[indexPath.row];
    cell.nameLabel.text = goal.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ собрано", goal.price];
    
    cell.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"testPic%d", arc4random_uniform(3) + 1]];
    
    CGFloat progress = [goal.progress floatValue] / 100;
    
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
        
        //NSLog(@"GOAL:\n name: %@,\n price %@,\n perMonth: %@,\n progress: %@,\n goalImage: %@,\n startDate: %@,\n finalDate: %@,\n complited: %@", goal.name, goal.price, goal.perMonth, goal.progress, goal.goalImage, goal.startDate, goal.finalDate, goal.complited ? @"NO" : @"YES");
    }
    
}

@end
