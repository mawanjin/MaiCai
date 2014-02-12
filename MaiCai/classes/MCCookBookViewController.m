//
//  MCCookBookViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCCookBookViewController.h"
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
#import "DDLogConfig.h"

@interface MCCookBookViewController ()

@end

@implementation MCCookBookViewController
{
    @private
        int page;
        int pageSize;
}


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
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"养身";
    
    page = 1;
    pageSize = 10;
    
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
    
    page = 1;
    [self getRecipes];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        //菜谱
        if(indexPath.row == self.recipes.count) {
            page++;
           // UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];
            
            [self getRecipes];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else {
            MCCookBookDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCCookBookDetailViewController"];
            vc.recipe = self.recipes[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:vc animated:YES];
        }
    }else {
        //养身
        if(indexPath.row == self.healthList.count) {
            page++;
            [self getHealthList];
             [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else{
            MCHealthDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCHealthDetailViewController"];
            vc.health = self.healthList[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        return self.recipes.count+1;
    }else {
        return self.healthList.count+1;
    }
    
}

#pragma mark- others
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
	DDLogVerbose(@"Selected index %i (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
    if(segmentedControl.selectedSegmentIndex == 0) {
        page = 1;
        [self.recipes removeAllObjects];
        //[self.tableView reloadData];
        [self getRecipes];
    }else {
        page = 1;
        [self.healthList removeAllObjects];
        //[self.tableView reloadData];
        [self getHealthList];
    }
}



- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction & UISwipeGestureRecognizerDirectionLeft){
        DDLogVerbose(@"Swiped Left.");
        if(self.segmentedControl.selectedSegmentIndex < 2) {
            [self.segmentedControl setSelectedSegmentIndex:(self.segmentedControl.selectedSegmentIndex+1) animated:YES];
            [self segmentedControlChangedValue:self.segmentedControl];
            
        }
    }
    if (sender.direction & UISwipeGestureRecognizerDirectionRight){
        DDLogVerbose(@"Swiped Right.");
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
            NSMutableArray* newData = [[MCVegetableManager getInstance]getRecipesByPage:page Pagesize:pageSize];
            
            [self.recipes addObjectsFromArray:newData];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:MC_ERROR_MSG_0001]; 
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
            });
        }
    });
}


-(void)getHealthList
{
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            NSMutableArray* newData = [[MCVegetableManager getInstance]getHealthListByPage:page Pagesize:pageSize];
            
            [self.healthList addObjectsFromArray:newData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
                                //重新调用UITableView的方法, 来生成行.
                
            });
        }
    });

}



@end
