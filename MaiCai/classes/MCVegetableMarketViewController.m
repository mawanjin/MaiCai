//
//  MCVegetableMarketViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCVegetableMarketViewController.h"
#import "MCVegetable.h"
#import "MCVegetableManager.h"
#import "MCMarket.h"
#import <QuartzCore/QuartzCore.h>
#import "Toast+UIView.h"
#import "MCMarketIndexNewsCell.h"
#import "MCMarketIndexCategoryCell.h"
#import "MCMarketIndexVegetablePriceCell.h"
#import "MCCategoryViewController.h"
#import "MCVegetableDetailViewController.h"
#import "HMSegmentedControl.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation MCVegetableMarketViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
           }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView* table = [[UITableView alloc]initWithFrame:CGRectMake(8, 355, 304, 66*3+25) style:UITableViewStylePlain];
    self.tableView = table;
    table.delegate = self;
    table.dataSource = self;
    [table registerNib:[UINib nibWithNibName:@"MCMarketIndexCookBookCell" bundle:nil] forCellReuseIdentifier:@"cookBookCell"];
    [self.scrollView addSubview:table];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(IS_IPHONE_5){
        self.scrollView.contentSize = CGSizeMake(320, self.newsView.frame.size.height+self.vegetablePriceCollectionView.frame.size.height+self.categoryCollectionView.frame.size.height+self.tableView.frame.size.height+20);
    }else{
        self.scrollView.contentSize = CGSizeMake(320, self.newsView.frame.size.height+self.vegetablePriceCollectionView.frame.size.height+self.categoryCollectionView.frame.size.height+self.tableView.frame.size.height+120);
    }
    
    self.scrollView.scrollEnabled = YES;
    
    [MBProgressHUD showHUDAddedTo:self.scrollView animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.data = [[MCVegetableManager getInstance]getMarketIndexInfo];
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
              [MBProgressHUD hideHUDForView:self.scrollView animated:YES];
                [self.vegetablePriceCollectionView reloadData];
                NSMutableArray* vegetables = self.data[@"prices"];
                self.vegetablePricePageControl.numberOfPages = (vegetables.count%6 ==0)?vegetables.count/6:(vegetables.count/6+1);
            });
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cookBookCell"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"热们菜谱";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 304, 25)];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 304, 25)];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"热门菜谱";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}


#pragma mark - uicollectionview

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UICollectionView* view = (UICollectionView*)scrollView;
    if([view.restorationIdentifier isEqualToString:@"newsCollectionView"]){
        CGFloat pageWidth = self.newsCollectionView.frame.size.width;
        self.newsPageControl.currentPage = self.newsCollectionView.contentOffset.x / pageWidth;
    }else if([view.restorationIdentifier isEqualToString:@"vegetablePriceCollectionView"]){
        CGFloat pageWidth = self.vegetablePriceCollectionView.frame.size.width-10;
        self.vegetablePricePageControl.currentPage = self.vegetablePriceCollectionView.contentOffset.x / pageWidth;
    }
}


-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    if([collectionView.restorationIdentifier isEqualToString:@"newsCollectionView"]){
        return 1;
    }else if([collectionView.restorationIdentifier isEqualToString:@"categoryCollectionView"]){
        return 1;
    }else if([collectionView.restorationIdentifier isEqualToString:@"vegetablePriceCollectionView"]){
        return 1;
    }
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    if([collectionView.restorationIdentifier isEqualToString:@"newsCollectionView"]){
        return 3;
    }else if([collectionView.restorationIdentifier isEqualToString:@"categoryCollectionView"]){
        return 6;
    }else if([collectionView.restorationIdentifier isEqualToString:@"vegetablePriceCollectionView"]){
        return 18;
    }
    return 1;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* myCell = nil;
    
    if([collectionView.restorationIdentifier isEqualToString:@"newsCollectionView"]){
        myCell = [collectionView
                  dequeueReusableCellWithReuseIdentifier:@"newsCollectionCell"
                  forIndexPath:indexPath];
        MCMarketIndexNewsCell* cell =(MCMarketIndexNewsCell*) myCell;
        if(indexPath.row == 0) {
           cell.newsLabel.text = @"新闻1.....";
        }else if(indexPath.row == 1) {
            cell.newsLabel.text = @"新闻2.....";

        }else{
            cell.newsLabel.text = @"新闻3.....";

        }
    }else if([collectionView.restorationIdentifier isEqualToString:@"categoryCollectionView"]){
        myCell = [collectionView
                  dequeueReusableCellWithReuseIdentifier:@"categoryCollectionCell"
                  forIndexPath:indexPath];
        MCMarketIndexCategoryCell* cell = (MCMarketIndexCategoryCell*)myCell;
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"蔬菜";
            cell.imageIcon.image = [UIImage imageNamed:@"c_shucai"];
        }else if(indexPath.row == 1) {
            cell.nameLabel.text = @"水果";
            cell.imageIcon.image = [UIImage imageNamed:@"c_shuiguo"];
        }else if(indexPath.row == 2) {
            cell.nameLabel.text = @"肉类";
            cell.imageIcon.image = [UIImage imageNamed:@"c_roulei"];
        }else if(indexPath.row == 3) {
            cell.nameLabel.text = @"豆制品";
            cell.imageIcon.image = [UIImage imageNamed:@"c_douzhipin"];
        }else if(indexPath.row == 4) {
            cell.nameLabel.text = @"炒货";
            cell.imageIcon.image = [UIImage imageNamed:@"c_chaohuo"];
        }else if(indexPath.row == 5) {
            cell.nameLabel.text = @"米面杂粮";
            cell.imageIcon.image = [UIImage imageNamed:@"c_shucai"];
        }
    }else if([collectionView.restorationIdentifier isEqualToString:@"vegetablePriceCollectionView"]){
        myCell = [collectionView
                  dequeueReusableCellWithReuseIdentifier:@"vegetablePriceCollectionCell"
                  forIndexPath:indexPath];
        MCMarketIndexVegetablePriceCell* cell = (MCMarketIndexVegetablePriceCell*)myCell;
        NSMutableArray* vegetables = self.data[@"prices"];
        MCVegetable* vegetable = vegetables[indexPath.row];
        cell.nameLabel.text = vegetable.name;
        cell.priceLabel.text = [[NSString alloc]initWithFormat:@"￥%.02f/%@",vegetable.price,vegetable.unit];
    }
    return myCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView.restorationIdentifier isEqualToString:@"categoryCollectionView"]){
        MCCategoryViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCCategoryViewController"];
        vc.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"蔬菜", @"水果", @"肉类", @"豆制品",@"炒货",@"米面杂粮"]];
        [vc.segmentedControl setSelectedSegmentIndex:indexPath.row];
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
            
        }];
    }else if([collectionView.restorationIdentifier isEqualToString:@"vegetablePriceCollectionView"]){
        NSMutableArray* vegetables = self.data[@"prices"];
        MCVegetable* vegetable = vegetables[indexPath.row];
        MCVegetableDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCVegetableDetailViewController"];
        vc.vegetable = vegetable;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
            
        }];

    }
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"divideReuseView" forIndexPath:indexPath];
//    return view;
//}

//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}


//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 1) {
//        return CGSizeMake(320, 200);
//    }
//    return CGSizeMake(320, 80);
//}

@end



