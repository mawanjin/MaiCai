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
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
#import "HMSegmentedControl.h"
#import "MCMarketTradeCell.h"
#import "MCVegetableDetailViewController.h"

@implementation MCCategoryViewController

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
    
    
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
	NSLog(@"Selected index %i (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
    [self.collectionView reloadData];
}


-(void)viewWillDisappear:(BOOL)animated
{
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.sourceData = [[MCVegetableManager getInstance]getMarketProducts];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });

        }
        @catch (NSException *exception) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.view makeToast:@"无法获取网络数据！"
                             duration:2.0
                             position:@"center"
                                title:@"提示"];
             });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                //移除ProgressBar
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
        
    });
}


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
    NSDictionary* dic = [[MCVegetableManager getInstance]getRelationshipBetweenProductAndImage];
     NSString* product_id =[[NSString alloc]initWithFormat:@"%d",vegetable.product_id];
    NSString* imageName = dic[product_id];
    [myCell.imageIcon setImage:[UIImage imageNamed:imageName]];
    myCell.nameLabel.text = vegetable.name;
    return myCell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCCategory* category = self.sourceData[self.segmentedControl.selectedSegmentIndex];
    MCVegetable* vegetable = category.vegetables[indexPath.row];
    MCVegetableDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCVegetableDetailViewController"];
    vc.vegetable = vegetable;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
        
    }];
}





- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender {
    
    
    if (sender.direction & UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"Swiped Left.");
        if(self.segmentedControl.selectedSegmentIndex < 5) {
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
@end
