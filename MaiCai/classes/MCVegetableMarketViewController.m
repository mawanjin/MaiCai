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
#import "MCAddressHelperViewController.h"

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
    
    self.navigationItem.title = @"莘庄";
    
    //search
    self.navigationItem.rightBarButtonItem=
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtnAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    
    //联系客服
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"配送说明" style:UIBarButtonItemStylePlain target:self action:@selector(addressHelperAction)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = item;
    
    
    UITableView* table = [[UITableView alloc]initWithFrame:CGRectMake(0, 325, 320, 66*0+50) style:UITableViewStylePlain];
    self.tableView = table;
    table.delegate = self;
    table.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [table registerNib:[UINib nibWithNibName:@"MCMarketIndexTipCell" bundle:nil] forCellReuseIdentifier:@"tipCell"];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:table];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showProgressHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        data = [[MCVegetableManager getInstance]getMarketIndexInfo];
        if (data) {
            recipes = data[@"recipes"];
            labels = data[@"labels"];
            products = data[@"products"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.tableView.frame = CGRectMake(0, 325, 320, 66*products.count+50);
                self.scrollView.contentSize = CGSizeMake(320, self.newsView.frame.size.height+self.quickOrderCollectionView.frame.size.height+self.categoryCollectionView.frame.size.height+self.tableView.frame.size.height+90);
                
                //注意这里scrollview不能滚动的原因是因为 MBProgressbar与toast需要在scrollview里面创建
                self.scrollView.scrollEnabled = YES;
                
                
                [self.quickOrderCollectionView reloadData];
                [self.categoryCollectionView reloadData];
                [self.tableView reloadData];
                self.vegetablePricePageControl.numberOfPages = (recipes.count%1 ==0)?recipes.count/1:(recipes.count/1+1);
                [self hideProgressHUD];
            });
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
                //[self showMsgHint:MC_ERROR_MSG_0001];
            });
        }
        
    });
    
    //self.scrollView.scrollEnabled = YES;
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
    [cell.icon loadImageByUrl:vegetable.image];
    
    cell.nameLabel.text = vegetable.name;
    cell.priceLabel.text = [[NSString alloc]initWithFormat:@"菜篮价：%.02f元/%@",vegetable.price,vegetable.unit];
    cell.descriptionLabel.text = vegetable.description;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCVegetable* vegetable = products[indexPath.row];
    MCVegetableDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCVegetableDetailViewController"];
    vc.vegetable = vegetable;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
        [vc setShowMsg:^(NSString *msg) {
            [self showMsgHint:msg];
        }];
        NSDictionary* obj = labels[indexPath.row];
        vc.labelId = [obj[@"id"]integerValue];
        vc.title = obj[@"name"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }else if([collectionView.restorationIdentifier isEqualToString:@"quickOrderCollectionView"]){
       MCRecipe* object = recipes[indexPath.row];
        MCQuickOrderViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCQuickOrderViewController"];
        vc.recipe = object;
        [vc setShowMsg:^(NSString *msg) {
            [self showMsgHint:msg];
        }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- others
-(void)showMsgHint:(NSString *)msg
{
    [self.scrollView makeToast:msg duration:1 position:@"center"];
}


-(void)searchBtnAction{
    MCSearchViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCSearchViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addressHelperAction {
    MCAddressHelperViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCAddressHelperViewController"];
    [vc setShowMsg:^{
        [[[UIAlertView alloc] initWithTitle:@"友情提示"
                                    message:@"目前配送仅支持下列显示的地址，其他地址请联系客服确认！" delegate:nil
                          cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc  animated:YES];
}
@end



