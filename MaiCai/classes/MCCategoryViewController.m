//
//  MCVegetableTradeViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCCategoryViewController.h"
#import "MCVegetable.h"
#import "MCVegetableManager.h"
#import "MCCategory.h"
#import "HMSegmentedControl.h"
#import "MCMarketTradeCell.h"
#import "MCVegetableDetailViewController.h"
#import "UIImageView+MCAsynLoadImage.h"


@implementation MCCategoryViewController

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
    
    [self showProgressHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.sourceData = [[MCVegetableManager getInstance]getMarketProducts];
        if (self.sourceData != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat yDelta;
                
                if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
                    yDelta = 20.0f;
                } else {
                    yDelta = 0.0f;
                }
                
                // Segmented control with scrolling
                NSMutableArray* categories = [[NSMutableArray alloc]init];
                for(int i=0;i<self.sourceData.count;i++) {
                    MCCategory* category = self.sourceData[i];
                    [categories addObject:category.name];
                }
                
                self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:categories];
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
                
                //快速集成下拉刷新
                MJRefreshHeaderView *header = [MJRefreshHeaderView header];
                header.scrollView = self.collectionView;
                header.delegate = self;

                [self.collectionView reloadData];
            });
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self hideProgressHUD];
        });
        
    });
}


/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    [_header free];
}


#pragma mark- uicollectionview
-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    @try {
        MCCategory* category = self.sourceData[self.segmentedControl.selectedSegmentIndex];
        return category.vegetables.count;
    }
    @catch (NSException *exception) {
        return 0;
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCMarketTradeCell* myCell = nil;
    myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gridCell" forIndexPath:indexPath];
    MCCategory* category = self.sourceData[self.segmentedControl.selectedSegmentIndex];
    MCVegetable* vegetable = category.vegetables[indexPath.row];
    [myCell.imageIcon setImage:[[UIImage alloc]init]];
    [myCell.imageIcon loadImageByUrl:vegetable.image];
    myCell.nameLabel.text = vegetable.name;
    myCell.priceLabel.text = [[NSString alloc]initWithFormat:@"%.02f元/斤",vegetable.price];
    return myCell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCCategory* category = self.sourceData[self.segmentedControl.selectedSegmentIndex];
    MCVegetable* vegetable = category.vegetables[indexPath.row];
    MCVegetableDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCVegetableDetailViewController"];
    vc.vegetable = vegetable;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- others
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction & UISwipeGestureRecognizerDirectionLeft){
        MCLog(@"Swiped Left.");
        if(self.segmentedControl.selectedSegmentIndex < (self.sourceData.count-1)) {
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

-(void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
	MCLog(@"Selected index %i (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
    [self.collectionView reloadData];
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.sourceData = [[MCVegetableManager getInstance]getMarketProducts];
        
        if (self.sourceData) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0];
            });
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if([refreshView isRefreshing]) {
                    [refreshView endRefreshing];
                }
            });
        }
    });
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.collectionView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    //NSLog(@"%@----刷新完毕", refreshView.class);
}

#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
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
}

@end
