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
#import "MCMarketIndexQuickOrderCell.h"
#import "MCCategoryViewController.h"
#import "MCVegetableDetailViewController.h"
#import "HMSegmentedControl.h"
#import "MCSearchViewController.h"
#import "MCTipsHeader.h"
#import "MCNetwork.h"
#import "MCQuickOrderViewController.h"
#import "MCRecipe.h"

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
    
    UITableView* table = [[UITableView alloc]initWithFrame:CGRectMake(8, 370, 304, 66*3+50) style:UITableViewStylePlain];
    self.tableView = table;
    table.delegate = self;
    table.dataSource = self;
    [table registerNib:[UINib nibWithNibName:@"MCMarketIndexTipCell" bundle:nil] forCellReuseIdentifier:@"tipCell"];
    
    self.navigationItem.rightBarButtonItem=
    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtnAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

    [self.scrollView addSubview:table];
}


-(void)searchBtnAction{
    MCSearchViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCSearchViewController"];
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:NO completion:^{
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(IS_IPHONE_5){
        self.scrollView.contentSize = CGSizeMake(320, self.newsView.frame.size.height+self.quickOrderCollectionView.frame.size.height+self.categoryCollectionView.frame.size.height+self.tableView.frame.size.height+40);
    }else{
        self.scrollView.contentSize = CGSizeMake(320, self.newsView.frame.size.height+self.quickOrderCollectionView.frame.size.height+self.categoryCollectionView.frame.size.height+self.tableView.frame.size.height+140);
    }
    //注意这里scrollview不能滚动的原因是因为 MBProgressbar与toast需要在scrollview里面创建
    self.scrollView.scrollEnabled = YES;
    
    [MBProgressHUD showHUDAddedTo:self.scrollView animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.data = [[MCVegetableManager getInstance]getMarketIndexInfo];
            self.recipes = [[MCVegetableManager getInstance]getRecipes];
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.scrollView makeToast:@"无法获取网络数据！"
                            duration:2.0
                            position:@"center"
                               title:@"提示"];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
              [MBProgressHUD hideHUDForView:self.scrollView animated:YES];
                [self.quickOrderCollectionView reloadData];
                self.vegetablePricePageControl.numberOfPages = (self.recipes.count%6 ==0)?self.recipes.count/6:(self.recipes.count/6+1);
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
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tipCell"];
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
    UIView* view = [MCTipsHeader initInstance];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
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
        return 6;
    }else if([collectionView.restorationIdentifier isEqualToString:@"quickOrderCollectionView"]){
        return self.recipes.count;
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
    }else if([collectionView.restorationIdentifier isEqualToString:@"quickOrderCollectionView"]){
        myCell = [collectionView
                  dequeueReusableCellWithReuseIdentifier:@"quickOrderCollectionCell"
                  forIndexPath:indexPath];
        MCMarketIndexQuickOrderCell* cell = (MCMarketIndexQuickOrderCell*)myCell;
        MCRecipe* obj = self.recipes[indexPath.row];
        cell.label.text = obj.name;
        NSString* source = [[NSString alloc]initWithFormat:@"%@",obj.image];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage* image = [[MCNetwork getInstance]loadImageFromSource:source];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.image.image = image;
            });
        });
 
    }
    return myCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView.restorationIdentifier isEqualToString:@"categoryCollectionView"]){
       
    }else if([collectionView.restorationIdentifier isEqualToString:@"quickOrderCollectionView"]){
       MCRecipe* object = self.recipes[indexPath.row];
        MCQuickOrderViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCQuickOrderViewController"];
        vc.recipe = object;
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



