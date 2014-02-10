//
//  MCMineCollectViewController.m
//  MaiCai
//
//  Created by Peng Jack on 14-1-13.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCMineCollectViewController.h"
#import "MCCookBookDetailViewController.h"
#import "MCVegetableManager.h"
#import "MCCookBookCell.h"
#import "MCNetwork.h"
#import "MCRecipe.h"
#import "HMSegmentedControl.h"
#import "UIImageView+MCAsynLoadImage.h"
#import "MCHealthCell.h"
#import "MCHealth.h"
#import "MCHealthDetailViewController.h"
#import "MCContextManager.h"
#import "MCUser.h"

@interface MCMineCollectViewController ()

@end

@implementation MCMineCollectViewController
int page_ = 1;
int pageSize_ = 10;

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
	[super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的收藏";
    
    CGFloat yDelta;
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        yDelta = 20.0f;
    } else {
        yDelta = 0.0f;
    }
    self.recipes = [[NSMutableArray alloc]init];
    self.healthList = [[NSMutableArray alloc]init];
    
    //segmentedControl
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"菜谱", @"百科"]];
    [self.segmentedControl setSelectedSegmentIndex:0];
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
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
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
    
    
    
    UIView* view = [[UIView alloc]initWithFrame:self.segmentedControl.frame];
    [view setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = view;
    
    page_ = 1;
    [self getRecipes];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        //菜谱
        if(indexPath.row == self.recipes.count) {
            page_++;
            [self getRecipes];
        }else {
            MCCookBookDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCCookBookDetailViewController"];
            vc.recipe = self.recipes[indexPath.row];
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
            }];
        }
    }else {
        //养身
        if(indexPath.row == self.healthList.count) {
            page_++;
            [self getHealthList];
        }else{
            MCHealthDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCHealthDetailViewController"];
            vc.health = self.healthList[indexPath.row];
            [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
            }];
            
        }
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        if(indexPath.row == self.recipes.count){
            //加载更多
            MCCookBookCell* cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
            return cell;
        }else {
            //菜谱
            MCCookBookCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cookBookCell"];
            MCRecipe* recipe = self.recipes[indexPath.row];
            [cell.image loadImageByUrl:recipe.image];
            cell.nameLabel.text = recipe.name;
            cell.introductionLabel.text = recipe.introduction;
            return cell;
        }
    }else {
        if(indexPath.row == self.healthList.count){
            //加载更多
            MCCookBookCell* cell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
            return cell;
        }else {
            //养身
            MCHealth* health = self.healthList[indexPath.row];
            MCHealthCell* cell = [tableView dequeueReusableCellWithIdentifier:@"healthCell"];
            cell.label.text = health.name;
            return cell;
        }
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.recipes.count) {
        return 43;
    }else {
        if(self.segmentedControl.selectedSegmentIndex == 0) {
            //菜谱
            return 73;
        }else {
            //养身
            return 43;
        }
    }
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
	NSLog(@"Selected index %i (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
    if(segmentedControl.selectedSegmentIndex == 0) {
        page_ = 1;
        [self.recipes removeAllObjects];
        [self getRecipes];
    }else {
        page_ = 1;
        [self.healthList removeAllObjects];
        [self getHealthList];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        return self.recipes.count+1;
    }else {
        return self.healthList.count+1;
    }
    
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction & UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"Swiped Left.");
        if(self.segmentedControl.selectedSegmentIndex < 2) {
            [self.segmentedControl setSelectedSegmentIndex:(self.segmentedControl.selectedSegmentIndex+1) animated:YES];
            [self segmentedControlChangedValue:self.segmentedControl];
            
        }
    }
    if (sender.direction & UISwipeGestureRecognizerDirectionRight){
        NSLog(@"Swiped Right.");
        if(self.segmentedControl.selectedSegmentIndex >0) {
            [self.segmentedControl setSelectedSegmentIndex:(self.segmentedControl.selectedSegmentIndex-1) animated:YES];
            [self segmentedControlChangedValue:self.segmentedControl];
        }
    }
}

-(void)getRecipes{
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
            NSMutableArray* newData = [[MCVegetableManager getInstance]getCollectionListByPage:page_ Pagesize:pageSize_ Recipe:true UserId:user.id];
            [self.recipes addObjectsFromArray:newData];
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


-(void)getHealthList
{
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
            NSMutableArray* newData = [[MCVegetableManager getInstance]getCollectionListByPage:page_ Pagesize:pageSize_ Recipe:false UserId:user.id];
            
            [self.healthList addObjectsFromArray:newData];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
