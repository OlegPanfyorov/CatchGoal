//
//  DetailViewController.m
//  catchGoal
//
//  Created by GeX on 15/03/15.
//  Copyright (c) 2015 iosDevCourse. All rights reserved.
//

#import "DetailViewController.h"
#import "goalInfoCell.h"
#import "goalOperationsCell.h"
#import "BEMSimpleLineGraphView.h"


#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface DetailViewController () <UIAlertViewDelegate, GoalInfoCellDelegate, UITableViewDelegate, UITableViewDataSource, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate, UIScrollViewDelegate>

@property (assign, nonatomic) CGFloat progressPercent;
@property (assign, nonatomic) int sumLeft;
@property (assign, nonatomic) int addMoneySum;
@property (strong, nonatomic) NSMutableArray* goalOperationsArray;
@property (strong, nonatomic) NSData *goalImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView* mediaDataView;
@property (strong, nonatomic) BEMSimpleLineGraphView* graph;


- (IBAction)showImage:(UIButton *)sender;
- (IBAction)addMoneyClicked:(UIBarButtonItem*)sender;
@end

UIButton* showProgress;
UIButton* showGraph;
BOOL flag;
@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    flag = YES;
    
    self.tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.alwaysBounceVertical = NO;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-main.png"]];
    imageView.frame = [UIScreen mainScreen].bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self.view insertSubview:imageView belowSubview:self.tableView];
    [self.view sendSubviewToBack:imageView];
    
    self.tableView.alwaysBounceVertical = NO;
    [self fetchAllGoalOperations];
    [self.navigationController.navigationBar setHidden:NO];
 
}

- (void)fetchAllGoalOperations {
    Goal *goal = [DataSingletone sharedModel].goalsArray[self.selectedItemInArray];
    self.goalOperationsArray = [NSMutableArray array];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"addDate" ascending:NO]];
    NSArray *sortedOperatoins = [[goal.operations allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    self.goalOperationsArray = [NSMutableArray arrayWithArray:sortedOperatoins];
    
    if ([goal.complited boolValue]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - BEMSimpleLineGraph

- (void) handleTap:(UITapGestureRecognizer*) tapGesture {
    
    if (flag) {
        [self showGraph];
        flag = NO;
    } else {
        [self showProgress];
        flag = YES;
    }
    
}

- (void) setupGraph:(BOOL) isHidden {
    
    if (isHidden) {
        [self.graph removeFromSuperview];
    } else {
    
    BEMSimpleLineGraphView *graph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, self.mediaDataView.frame.size.width - 10, self.mediaDataView.frame.size.height - 5)];
        graph.dataSource = self;
        graph.delegate = self;
        graph.colorTop = [UIColor clearColor];
        graph.colorBottom = [UIColor clearColor];
        graph.colorLine = [UIColor colorWithRed:1 green:0.39 blue:0.33 alpha:1];
        graph.widthLine = 2.0;
        graph.sizePoint = 8.0;
        graph.colorXaxisLabel = [UIColor whiteColor];
        graph.colorYaxisLabel = [UIColor whiteColor];
        graph.colorReferenceLines = [UIColor colorWithWhite:1.0 alpha:0.15];
        graph.colorPoint = [UIColor whiteColor];
        graph.enableTouchReport = YES;
        graph.enablePopUpReport = YES;
        graph.enableBezierCurve = YES;
        graph.enableYAxisLabel = YES;
        graph.enableXAxisLabel = YES;
        graph.autoScaleYAxis = YES;
        graph.alwaysDisplayDots = YES;
        graph.enableReferenceXAxisLines = YES;
        graph.enableReferenceYAxisLines = YES;
        graph.enableReferenceAxisFrame = YES;
        graph.animationGraphStyle = BEMLineAnimationDraw;
        graph.hidden = isHidden;
        graph.userInteractionEnabled = YES;
        self.graph = graph;
 
    [self.mediaDataView addSubview:graph];
    }
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    
    return [self.goalOperationsArray count]; // Number of points in the graph.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    
    NSArray* reversedArray = [[self.goalOperationsArray reverseObjectEnumerator] allObjects];
    self.operations = [reversedArray objectAtIndex:index];
    return [self.operations.addSum floatValue]; // The value of the point on the Y-Axis for the index.
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"dd.MM"];
    
    NSArray* reversedArray = [[self.goalOperationsArray reverseObjectEnumerator] allObjects];
    self.operations = [reversedArray objectAtIndex:index];
    NSString *date = [dateFormater stringFromDate:self.operations.addDate];
    
    return date;
}

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return CURRENCY_SYMBOL;
}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 2;
}

- (NSInteger)numberOfYAxisLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 4;
}

#pragma mark - Actions

- (IBAction)previousGoalButtonTap:(UIButton *)sender {
    self.selectedItemInArray--;
    [self fetchAllGoalOperations];
    [self.tableView reloadData];
}

- (IBAction)nextGoalButtonTap:(UIButton *)sender {
    self.selectedItemInArray++;
    [self fetchAllGoalOperations];
    [self.tableView reloadData];
}

- (void)showGraph {
    for (UIView* view in self.mediaDataView.subviews) {
            view.hidden = YES;
        
    }
    
    [self setupGraph:NO];

}

- (void)showProgress {
    [self setupGraph:YES];
    
    for (UIView* view in self.mediaDataView.subviews) {
            view.hidden = NO;
    }
    

    [self.tableView reloadData];

}

- (IBAction)showImage:(UIButton *)sender {

    if (self.goalImage) {
        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
        imageInfo.image = [UIImage imageWithData:self.goalImage];
        //  imageInfo.referenceRect = self.bigImageButton.frame;
        //  imageInfo.referenceView = self.bigImageButton.superview;
        
        JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                               initWithImageInfo:imageInfo
                                               mode:JTSImageViewControllerMode_Image
                                               backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
        
        [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    }
}

-(IBAction)addMoneyClicked:(UIBarButtonItem*)sender {
    self.tableView.scrollEnabled = NO;
    sender.enabled = NO;
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SlideInFromTop;
    alert.backgroundType = Blur;
    
    UITextField *textField = [alert addTextField:@"Сумма"];
    // [textField becomeFirstResponder];
    
    [alert addButton:@"Готово" actionBlock:^(void) {
        self.addMoneySum = [textField.text intValue];
        
        if (self.addMoneySum >= 1 && self.addMoneySum <= self.sumLeft && self.addMoneySum != self.sumLeft) {
            [self addNewSumToContextWithCompletedFlag:NO];
            sender.enabled = YES;
            [self.graph reloadGraph];
        } else if (self.addMoneySum == self.sumLeft) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SCLAlertView *alertWithComplited = [[SCLAlertView alloc] init];
                [alertWithComplited showSuccess:self title:@"Завершено" subTitle:@"Вы выполнили данную цель." closeButtonTitle:@"Готово" duration:0.0f];
                [self addNewSumToContextWithCompletedFlag:YES];
                [alertWithComplited alertIsDismissed:^{
                    self.tableView.scrollEnabled = YES;
                    sender.enabled = NO;
                }];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                SCLAlertView *alertWithError = [[SCLAlertView alloc] init];
                [alertWithError showError:self title:@"Ошибка" subTitle:[NSString stringWithFormat:@"Введенная вами сумма не должна превышать %d %@", self.sumLeft, CURRENCY_SYMBOL] closeButtonTitle:@"OK" duration:0.0f]; // Error
                alertWithError.showAnimationType = SlideInFromTop;
                
                [alertWithError alertIsDismissed:^{
                    self.tableView.scrollEnabled = YES;
                    sender.enabled = YES;
                    
                }];
                
            });
        }
    }];
    
    [alert addButton:@"Отмена" actionBlock:^(void) {
        self.tableView.scrollEnabled = YES;
        sender.enabled = YES;
        
    }];
    
    [alert showSuccess:self title:@"Внесите сумму"
              subTitle:[NSString stringWithFormat:@"До достижения цели осталось собрать: %d %@", self.sumLeft, CURRENCY_SYMBOL]
      closeButtonTitle:nil duration:0.0f];
}

- (void) addNewSumToContextWithCompletedFlag:(BOOL) isCompleted {
    Goal *goal = [DataSingletone sharedModel].goalsArray[self.selectedItemInArray];
    goal.complited = [NSNumber numberWithBool:isCompleted];
    self.operations = [GoalOperations createEntity];
    self.operations.addSum = [NSNumber numberWithInt: self.addMoneySum];
    self.operations.addDate = [NSDate date];
    [goal addOperationsObject:self.operations];
    goal.progress = [NSNumber numberWithInt:self.addMoneySum + [goal.progress intValue]];
    [self.goalOperationsArray insertObject:self.operations atIndex:0];
    [[DataSingletone sharedModel] saveContext];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    self.tableView.scrollEnabled = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.37 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(NSString*) convertDateToString:(NSDate*) dateToConvert {
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"dd.MM.yyyy : hh.mm"];
    NSString *date = [dateFormater stringFromDate:dateToConvert];
    NSString* subString = [date substringToIndex:10];
    return subString;
}

- (void) showPhoto {
    NSLog(@"goal image clicked");
    

    
    //    // Create an array to store IDMPhoto objects
    //    NSMutableArray *photos = [NSMutableArray new];
    //    IDMPhoto *photo = [IDMPhoto photoWithImage:[UIImage imageWithData:_goalImage]];
    //    [photos addObject:photo];
    //
    //    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    //    //browser.scaleImage = [UIImage imageNamed:_chartsArray[indexPath.row]];
    //    //[browser setInitialPageIndex:indexPath.row];
    //    browser.usePopAnimation = YES;
    //    browser.displayArrowButton = NO;
    //    browser.displayDoneButton = YES;
    //    browser.displayActionButton = NO;
    //    browser.disableVerticalSwipe = NO;
    //    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        header.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, header.frame.size.width, header.frame.size.height)];
        name.textColor = [UIColor whiteColor];
        name.font = [UIFont fontWithName:@"Roboto-Regular" size:14];
        name.text = [[self tableView: tableView titleForHeaderInSection:1] uppercaseString];
        [header addSubview:name];
        
        return header;
    } else   {
        return 0;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else
        return [self.goalOperationsArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return [NSString stringWithFormat:@"История платежей (%lu)", (unsigned long)[self.goalOperationsArray count]];
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 242;
    } else
        return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Goal *goal = [DataSingletone sharedModel].goalsArray[self.selectedItemInArray];
    
    if (indexPath.section == 0) {
        self.navigationItem.title = goal.name;
        static NSString* infoCellIdentifier = @"infoCell";
        goalInfoCell* infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellIdentifier];
        self.mediaDataView = infoCell.mediaDataView;
        self.sumLeft = [goal.price floatValue] - [goal.progress floatValue];
        if (self.selectedItemInArray == 0) {
            infoCell.previousGoalButton.hidden = YES;
            // For next button
            
        } else {
            infoCell.previousGoalButton.hidden = NO;
        }
        
        if (self.selectedItemInArray + 2 > [[DataSingletone sharedModel].goalsArray count]) {
            infoCell.nextGoalButton.hidden = YES;
        } else {
            infoCell.nextGoalButton.hidden = NO;
        }
        
        infoCell.delegate = self;
        infoCell.nameLabel.text = goal.name;
        infoCell.priceLabel.text = [NSString stringWithFormat:@"%@ %@ собрано из %@ %@", goal.progress, CURRENCY_SYMBOL, goal.price, CURRENCY_SYMBOL];
        //infoCell.progressMoney.text = [NSString stringWithFormat:@"%@ %@", goal.progress, CURRENCY_SYMBOL];
        infoCell.startDateLabel.text = [NSString stringWithFormat:@"Начало: %@", [self convertDateToString:goal.startDate]];
        infoCell.finalDateLabel.text = [NSString stringWithFormat:@"Финиш: %@", [self convertDateToString:goal.finalDate]];
        
        _goalImage = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:goal.imagePath]];
        if (goal.imagePath) {
            [infoCell.goalImageButton setBackgroundImage:[UIImage imageWithData:_goalImage]
                                                forState:UIControlStateNormal];
            [infoCell.goalImageButton setBackgroundImage:[UIImage imageWithData:_goalImage]
                                                forState:UIControlStateHighlighted];
        } else {
            [infoCell.goalImageButton setBackgroundImage:[UIImage imageNamed:@"no_photo"]
                                                forState:UIControlStateNormal];
            [infoCell.goalImageButton setBackgroundImage:[UIImage imageNamed:@"no_photo"]
                                                forState:UIControlStateHighlighted];
        }
        
        self.progressPercent = [goal.progress floatValue] / [goal.price floatValue];
        
        // [infoCell.circleProgressLabel setProgress:0];
        infoCell.circleProgressLabel.progressLabelVCBlock = ^(KAProgressLabel *label, CGFloat progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [label setText:[NSString stringWithFormat:@"%.0f%%", (progress*100)]];
                [label setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
                [label setFont:[UIFont systemFontOfSize:50.f]];
                
            });
        };
        
        UITapGestureRecognizer* tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleTap:)];
        
        tapGesture.numberOfTapsRequired = 2;
        [self.mediaDataView addGestureRecognizer:tapGesture];
        
        [infoCell.circleProgressLabel setBackBorderWidth: 8];
        [infoCell.circleProgressLabel setFrontBorderWidth: 8];
        
        [infoCell.circleProgressLabel setColorTable: @{
                                                       NSStringFromProgressLabelColorTableKey(ProgressLabelTrackColor):
                                                           [UIColor colorWithWhite:1.0 alpha:0.15],
                                                       NSStringFromProgressLabelColorTableKey(ProgressLabelProgressColor):
                                                           [UIColor colorWithRed:1 green:0.39 blue:0.33 alpha:1],
                                                       }];
        [infoCell.circleProgressLabel setProgress:self.progressPercent timing:TPPropertyAnimationTimingEaseOut duration:2.f delay:0.0];
        [infoCell.nextGoalButton addTarget:self action:@selector(nextGoalButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [infoCell.previousGoalButton addTarget:self action:@selector(previousGoalButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        return infoCell;
        
    } else {
        static NSString* operationsCellIdentifier = @"operationsCell";
        goalOperationsCell* operationsCell = [tableView dequeueReusableCellWithIdentifier:operationsCellIdentifier];
        self.operations = [self.goalOperationsArray objectAtIndex:indexPath.row];
        operationsCell.sumLabel.text = [NSString stringWithFormat:@"+ %@ %@", [self.operations.addSum stringValue], CURRENCY_SYMBOL];
        operationsCell.dateLabel.text = [self convertDateToString:self.operations.addDate];
        return operationsCell;
    }
    
    return nil;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIEdgeInsets inset = {0,0,0,0};
    self.tableView.contentInset = inset;
    
    
}
@end
