//
//  MCMineOrderViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMineOrderViewController.h"
#import "MCTradeManager.h"
#import "MCContextManager.h"
#import "MCUser.h"
#import "MCOrderCell.h"
#import "MCOrder.h"
#import "MCVegetableManager.h"
#import "MCOrderDetailViewController.h"
#import "UIImageView+MCAsynLoadImage.h"
#import "DDLogConfig.h"

@implementation MCMineOrderViewController

#pragma mark- base
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat yDelta;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        yDelta = 20.0f;
    } else {
        yDelta = 0.0f;
    }
    
    // Segmented control with scrolling
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"待付款", @"待发货",@"已配送"]];
    self.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl.font = [UIFont systemFontOfSize:15];
    self.segmentedControl.selectionIndicatorHeight = 2;
    self.segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:0.41f green:0.75f blue:0.27f alpha:1.00f];
    self.segmentedControl.selectedTextColor = [UIColor colorWithRed:0.41f green:0.75f blue:0.27f alpha:1.00f];
    self.segmentedControl.textColor = [UIColor grayColor];
    self.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl.scrollEnabled = YES;
    self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [self.segmentedControl setFrame:CGRectMake(0, 40 + yDelta, 320, 40)];
    [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
    
    
    //手势滑动控制
    UISwipeGestureRecognizer* swipeGestureRecognizer1 = [[UISwipeGestureRecognizer alloc]
                                                         initWithTarget:self
                                                         action:@selector(handleSwipe:)];
    swipeGestureRecognizer1.direction =
    UISwipeGestureRecognizerDirectionLeft;
    swipeGestureRecognizer1.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeGestureRecognizer1];
    
    UISwipeGestureRecognizer* swipeGestureRecognizer2 = [[UISwipeGestureRecognizer alloc]
                                                         initWithTarget:self
                                                         action:@selector(handleSwipe:)];
    swipeGestureRecognizer2.direction =
    UISwipeGestureRecognizerDirectionRight;
    swipeGestureRecognizer2.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeGestureRecognizer2];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self showProgressHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
            //初始化待付款订单数据
            NSString* status = [[NSString alloc]initWithFormat:@"[%d]",TO_PAY];
            self.data = [[MCTradeManager getInstance]getOrdersByUserId:user.userId Status:status];
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.segmentedControl setSelectedSegmentIndex:0];
                [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
                [self.tableView reloadData];
                [self hideProgressHUD];
            });
        }
    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- others
- (void) segmentChanged:(UISegmentedControl *)paramSender{
    NSInteger index = [paramSender selectedSegmentIndex];
    [self showProgressHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            if(index == 0) {
                MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
                NSString* status = [[NSString alloc]initWithFormat:@"[%d]",TO_PAY];
                self.data = [[MCTradeManager getInstance]getOrdersByUserId:user.userId Status:status];
            }else if(index == 1) {
                MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
                NSString* status = [[NSString alloc]initWithFormat:@"[%d]",TO_SHIP];
                self.data = [[MCTradeManager getInstance]getOrdersByUserId:user.userId Status:status];
            }else{
                MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
                NSString* status = [[NSString alloc]initWithFormat:@"[%d]",SHIPPED];
                self.data = [[MCTradeManager getInstance]getOrdersByUserId:user.userId Status:status];
            }

        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
               [self hideProgressHUD];
               [self.tableView reloadData];
            });
        }
    });
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    
    
    if (sender.direction & UISwipeGestureRecognizerDirectionLeft){
        DDLogVerbose(@"Swiped Left.");
        if(self.segmentedControl.selectedSegmentIndex < 2) {
            [self.segmentedControl setSelectedSegmentIndex:(self.segmentedControl.selectedSegmentIndex+1) animated:YES];
            [self segmentChanged:(UISegmentedControl*)self.segmentedControl];
            
        }
    }
    if (sender.direction & UISwipeGestureRecognizerDirectionRight){
        DDLogVerbose(@"Swiped Right.");
        if(self.segmentedControl.selectedSegmentIndex >0) {
            [self.segmentedControl setSelectedSegmentIndex:(self.segmentedControl.selectedSegmentIndex-1) animated:YES];
            [self segmentChanged:(UISegmentedControl*)self.segmentedControl];
        }
    }
}


#pragma mark- tableview
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    MCOrderDetailViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCOrderDetailViewController"];
    vc.order = self.data[indexPath.row];
    vc.previousView = self;
    [self.navigationController pushViewController:vc animated:YES];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCOrderCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    MCOrder* order = self.data[indexPath.row];
    [cell.imageIcon loadImageByUrl:order.image];
    
    cell.shopNameLabel.text = order.shopName;
    cell.createTimeLabel.text = order.dateAdded;
    cell.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"￥%.02f元",order.total];
    cell.addressLabel.text = order.address;
    cell.orderNumLabel.text = order.orderNo;

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

@end
