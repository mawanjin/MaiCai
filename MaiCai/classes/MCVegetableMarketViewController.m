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
#import "MCMarketIndexNewsCell.h"
#import "MCMarketIndexCategoryCell.h"
#import "MCMarketIndexQuickOrderCell.h"
#import "MCCategoryViewController.h"
#import "MCVegetableDetailViewController.h"
#import "HMSegmentedControl.h"
#import "MCSearchViewController.h"
#import "MCMarketIndexTipsHeader.h"
#import "MCNetwork.h"
#import "MCQuickOrderViewController.h"
#import "MCRecipe.h"
#import "UIImageView+MCAsynLoadImage.h"
#import "UIColor+ColorWithHex.h"
#import "MCMarketIndexTipCell.h"
#import "MCLabelDetailViewController.h"
#import "SVProgressHUD.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@implementation MCVegetableMarketViewController
{
   @private
        NSMutableArray*  recipes;
        NSMutableArray*  labels;
        NSMutableArray*  products;
        NSMutableDictionary* data;
}

#pragma mark- base
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
    
    self.navigationItem.rightBarButtonItem=
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtnAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.tableView removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showProgressHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            data = [[MCVegetableManager getInstance]getMarketIndexInfo];
            recipes = data[@"recipes"];
            labels = data[@"labels"];
            products = data[@"products"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UITableView* table = [[UITableView alloc]initWithFrame:CGRectMake(0, 325, 320, 66*products.count+50) style:UITableViewStylePlain];
                self.tableView = table;
                table.delegate = self;
                table.dataSource = self;
                self.tableView.backgroundColor = [UIColor clearColor];
                [table registerNib:[UINib nibWithNibName:@"MCMarketIndexTipCell" bundle:nil] forCellReuseIdentifier:@"tipCell"];
                table.separatorStyle = UITableViewCellSeparatorStyleNone;
                [self.scrollView addSubview:table];
                
                if(IS_IPHONE_5){
                    self.scrollView.contentSize = CGSizeMake(320, self.newsView.frame.size.height+self.quickOrderCollectionView.frame.size.height+self.categoryCollectionView.frame.size.height+self.tableView.frame.size.height+90);
                }else{
                    self.scrollView.contentSize = CGSizeMake(320, self.newsView.frame.size.height+self.quickOrderCollectionView.frame.size.height+self.categoryCollectionView.frame.size.height+self.tableView.frame.size.height+170);
                }
                //注意这里scrollview不能滚动的原因是因为 MBProgressbar与toast需要在scrollview里面创建
                self.scrollView.scrollEnabled = YES;
                
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
                [self.quickOrderCollectionView reloadData];
                [self.categoryCollectionView reloadData];
                self.vegetablePricePageControl.numberOfPages = (recipes.count%1 ==0)?recipes.count/1:(recipes.count/1+1);
            });
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCMarketIndexTipCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tipCell"];
    MCVegetable* vegetable = products[indexPath.row];
    //NSDictionary* dic = [[MCVegetableManager getInstance]getRelationshipBetweenProductAndImage];
    [cell.icon loadImageByUrl:vegetable.image];
    
    cell.nameLabel.text = vegetable.name;
    cell.descriptionLabel.text = [[NSString alloc]initWithFormat:@"市场价：%.02f元/%@",vegetable.price,vegetable.unit];
    if(indexPath.row == (products.count-1)) {
        cell.divideLine.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return products.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"热们菜谱";
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCVegetable* vegetable = products[indexPath.row];
    MCVegetableDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCVegetableDetailViewController"];
    vc.vegetable = vegetable;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
        
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MCMarketIndexTipsHeader* view = [MCMarketIndexTipsHeader initInstance];
    view.newsLabel.text = data[@"tip"];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}


#pragma mark - UICollectionView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UICollectionView* view = (UICollectionView*)scrollView;
    if([view.restorationIdentifier isEqualToString:@"newsCollectionView"]){
        CGFloat pageWidth = self.newsCollectionView.frame.size.width;
        self.newsPageControl.currentPage = self.newsCollectionView.contentOffset.x / pageWidth;
    }else if([view.restorationIdentifier isEqualToString:@"quickOrderCollectionView"]){
        CGFloat pageWidth = self.quickOrderCollectionView.frame.size.width-10;
        self.vegetablePricePageControl.currentPage = self.quickOrderCollectionView.contentOffset.x / pageWidth;
    }
}


-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    if([collectionView.restorationIdentifier isEqualToString:@"categoryCollectionView"]){
        return 1;
    }else if([collectionView.restorationIdentifier isEqualToString:@"quickOrderCollectionView"]){
        return 1;
    }
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    if([collectionView.restorationIdentifier isEqualToString:@"categoryCollectionView"]){
        return labels.count;
    }else if([collectionView.restorationIdentifier isEqualToString:@"quickOrderCollectionView"]){
        return recipes.count;
    }
    return 1;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* myCell = nil;
    
    
    if([collectionView.restorationIdentifier isEqualToString:@"categoryCollectionView"]){
        myCell = [collectionView
                  dequeueReusableCellWithReuseIdentifier:@"categoryCollectionCell"
                  forIndexPath:indexPath];
        MCMarketIndexCategoryCell* cell = (MCMarketIndexCategoryCell*)myCell;
        NSDictionary* obj = labels[indexPath.row];
        cell.nameLabel.text = obj[@"name"];
        [cell.imageIcon loadImageByUrl:obj[@"icon"]];
        NSString* color = obj[@"color"];
        [cell setBackgroundColor:[UIColor colorWithHexString:color andAlpha:1]];
    }else if([collectionView.restorationIdentifier isEqualToString:@"quickOrderCollectionView"]){
        myCell = [collectionView
                  dequeueReusableCellWithReuseIdentifier:@"quickOrderCollectionCell"
                  forIndexPath:indexPath];
        MCMarketIndexQuickOrderCell* cell = (MCMarketIndexQuickOrderCell*)myCell;
        MCRecipe* obj = recipes[indexPath.row];
        cell.label.text = obj.name;
        NSString* source = [[NSString alloc]initWithFormat:@"%@",obj.image];
        [cell.image loadImageByUrl:source];
    }
    return myCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView.restorationIdentifier isEqualToString:@"categoryCollectionView"]){
        MCLabelDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCLabelDetailViewController"];
        vc.previousView = self;
        NSDictionary* obj = labels[indexPath.row];
        vc.labelId = [obj[@"id"]integerValue];
        vc.title = obj[@"name"];
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
            
        }];

    }else if([collectionView.restorationIdentifier isEqualToString:@"quickOrderCollectionView"]){
       MCRecipe* object = recipes[indexPath.row];
        MCQuickOrderViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCQuickOrderViewController"];
        vc.recipe = object;
        vc.previousView = self;
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
        }];
    }
}

#pragma mark- others
-(void)showMsgHint:(NSString *)msg
{
    [self.scrollView makeToast:msg duration:1 position:@"center"];
}


-(void)searchBtnAction{
    MCSearchViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCSearchViewController"];
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
        
    }];
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



