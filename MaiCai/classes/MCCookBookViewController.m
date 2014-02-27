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
    
    // 3.1.下拉刷新
    [self addHeader];
    
    // 3.2.上拉加载更多
    [self addFooter];
    
    [self.header beginRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    [_header free];
    [_footer free];
}


#pragma mark- tableview
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        MCCookBookDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCCookBookDetailViewController"];
        vc.recipe = self.recipes[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:vc animated:YES];
    }else {
        MCHealthDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCHealthDetailViewController"];
        vc.health = self.healthList[indexPath.row];
        [vc setShowMsg:^(NSString *msg) {
            [self showMsgHint:msg];
        }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        MCCookBookCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cookBookCell"];
        MCRecipe* recipe = self.recipes[indexPath.row];
        [cell.image setImage:[[UIImage alloc]init]];
        [cell.image loadImageScaleByUrl:recipe.image];
        cell.nameLabel.text = recipe.name;
        cell.introductionLabel.text = recipe.introduction;
        return cell;
    }else {
        MCHealth* health = self.healthList[indexPath.row];
        MCHealthCell* cell = [tableView dequeueReusableCellWithIdentifier:@"healthCell"];
        cell.label.text = health.name;
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        //菜谱
        return 73;
    }else {
        //养身
        return 43;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.segmentedControl.selectedSegmentIndex == 0) {
        return self.recipes.count;
    }else {
        return self.healthList.count;
    }
    
}

#pragma mark- others
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
	MCLog(@"Selected index %i (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
    [self.recipes removeAllObjects];
    [self.healthList removeAllObjects];
    [self.tableView reloadData];
    [self.header beginRefreshing];

}


- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction & UISwipeGestureRecognizerDirectionLeft){
        MCLog(@"Swiped Left.");
        if(self.segmentedControl.selectedSegmentIndex < 2) {
            [self.segmentedControl setSelectedSegmentIndex:(self.segmentedControl.selectedSegmentIndex+1) animated:YES];
            [self segmentedControlChangedValue:self.segmentedControl];
        }
    }
    if (sender.direction & UISwipeGestureRecognizerDirectionRight){
        MCLog(@"Swiped Right.");
        if(self.segmentedControl.selectedSegmentIndex >0) {
            [self.segmentedControl setSelectedSegmentIndex:(self.segmentedControl.selectedSegmentIndex-1) animated:YES];
            [self segmentedControlChangedValue:self.segmentedControl];
        }
    }
}


#pragma mark- 下拉刷新，上拉加载更多
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        page++;
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            //菜谱
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray* newData = [[MCVegetableManager getInstance]getRecipesByPage:page Pagesize:pageSize Cache:YES];
                if (newData) {
                    int count = self.recipes.count;
                    [self.recipes addObjectsFromArray:newData];
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    
                    for (int i=0; i<newData.count; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count+i inSection:0];
                        [indexPaths addObject: indexPath];
                    }
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self performSelector:@selector(doneWithLoadMore:IndexPaths:) withObject:refreshView withObject:indexPaths];
                    });
                }else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        //[self showMsgHint:MC_ERROR_MSG_0001];
                        if([refreshView isRefreshing]) {
                            [refreshView endRefreshing];
                        }
                    });
                }
            });
        }else {
            //养身
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray* newData = [[MCVegetableManager getInstance]getHealthListByPage:page Pagesize:pageSize Cache:YES];
                if (newData) {
                    int count = self.healthList.count;
                    [self.healthList addObjectsFromArray:newData];
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    
                    for (int i=0; i<newData.count; i++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count+i inSection:0];
                        [indexPaths addObject: indexPath];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSelector:@selector(doneWithLoadMore:IndexPaths:) withObject:refreshView withObject:indexPaths];
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[self showMsgHint:MC_ERROR_MSG_0001];
                        if([refreshView isRefreshing]) {
                            [refreshView endRefreshing];
                        }
                    });
                }
            });
        }
        //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    self.footer = footer;
}


- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        page = 1;
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.recipes removeAllObjects];
                NSMutableArray* newData = [[MCVegetableManager getInstance]getRecipesByPage:page Pagesize:pageSize Cache:NO];
                if (newData) {
                    if (self.recipes == nil) {
                        self.recipes = [[NSMutableArray alloc]init];
                    }
                    [self.recipes addObjectsFromArray:newData];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self performSelector:@selector(doneWithRefresh:) withObject:refreshView afterDelay:0.0];
                    });
                }else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        //[self showMsgHint:MC_ERROR_MSG_0001];
                        if([refreshView isRefreshing]) {
                            [refreshView endRefreshing];
                        }
                    });
                }
            });
        }else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self.healthList removeAllObjects];
                NSMutableArray* newData = [[MCVegetableManager getInstance]getHealthListByPage:page Pagesize:pageSize Cache:NO];
                if (newData) {
                    if (self.healthList == nil) {
                        self.healthList = [[NSMutableArray alloc]init];
                    }
                    [self.healthList addObjectsFromArray:newData];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self performSelector:@selector(doneWithRefresh:) withObject:refreshView afterDelay:0.0];
                    });
                }else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        //[self showMsgHint:MC_ERROR_MSG_0001];
                        if([refreshView isRefreshing]) {
                            [refreshView endRefreshing];
                        }
                    });
                }
            });
        }
    };
    
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        //NSLog(@"%@----刷新完毕", refreshView.class);
    };
    
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                //NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                //NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                //NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    
    self.header = header;
}

-(void)doneWithLoadMore:(MJRefreshBaseView *)refreshView IndexPaths:(NSMutableArray*)indexPaths
{
    [refreshView endRefreshing];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
}

- (void)doneWithRefresh:(MJRefreshBaseView *)refreshView
{
    [refreshView endRefreshing];
    // 刷新表格
    [self.tableView reloadData];
    //(最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    
}
@end
