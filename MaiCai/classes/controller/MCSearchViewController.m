//
//  MCSearchViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-19.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCSearchViewController.h"
#import "MCVegetableManager.h"
#import "MCHotWordsCell.h"
#import "MCSearchResultCell.h"
#import "MCNetwork.h"
#import "MCVegetableDetailViewController.h"
#import "MCVegetable.h"
#import "MCCookBookDetailViewController.h"
#import "MCRecipe.h"
#import "MCHealthDetailViewController.h"
#import "MCHealth.h"
#import "UIImageView+MCAsynLoadImage.h"
#import "MBProgressHUD.h"

@interface MCSearchViewController ()

@end

@implementation MCSearchViewController
{
    @private
        bool flag;
        NSString* searchKey;
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
    //设置Navigation Bar背景图片
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBarTintColor:[UIColor colorWithRed:0.33f green:0.71f blue:0.06f alpha:1.00f]];
    
    //navbar字体
    [navBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    flag = false;
    UIBarButtonItem* item = [[UIBarButtonItem alloc]
                             init];
    
    //使用自定义的返回按钮
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 12, 20)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [item setCustomView:backBtn];
    self.navigationItem.leftBarButtonItem= item;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.hotWords = [[MCVegetableManager getInstance]getHotWordsByQuantity:10];
        if (self.hotWords) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.tableView reloadData];
            });
        }else {
            
        }
    });
    [self.searchDisplayController.searchResultsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if(!flag) {
            return self.suggestData.count;
        }else {
            return self.filterData.count;
        }
    } else {
        return self.hotWords.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a cell from self's table view.
	UITableViewCell *cell = Nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if(!flag) {
            //建议结果
            MCHotWordsCell* hotCell = [self.tableView dequeueReusableCellWithIdentifier:@"hotwordsCell"];
            hotCell.hotwordLabel.text = self.suggestData[indexPath.row];
            cell = hotCell;
        }else{
            //搜索结果
            if(indexPath.row != self.filterData.count) {
                NSDictionary* obj = self.filterData[indexPath.row];
                MCSearchResultCell* resultCell = [self.tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
                [resultCell.image loadImageByUrl:obj[@"image"]];
                resultCell.label.text = obj[@"name"];
                cell = resultCell;
            }else {
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
            }
        }
    } else {
        MCHotWordsCell* hotCell = [self.tableView dequeueReusableCellWithIdentifier:@"hotwordsCell"];
        hotCell.hotwordLabel.text = self.hotWords[indexPath.row];
        cell = hotCell;

    }
	return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if(!flag) {
            //建议结果
            flag = true;
            self.searchDisplayController.searchBar.text = self.suggestData[indexPath.row];
            [self.searchDisplayController.searchBar resignFirstResponder];
        }else{
            //搜索结果
            if(indexPath.row != self.filterData.count) {
                NSDictionary* obj = self.filterData[indexPath.row];
                if([obj[@"type"]integerValue] == 2 ) {
                    MCVegetableDetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCVegetableDetailViewController"];
                    MCVegetable* temp = [[MCVegetable alloc]init];
                    temp.id = [obj[@"id"]integerValue];
                    temp.product_id = [obj[@"image"]integerValue];
                    temp.name = obj[@"name"];
                    vc.vegetable = temp;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([obj[@"type"]integerValue] == 1) {
                    MCCookBookDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCCookBookDetailViewController"];
                    MCRecipe* recipe = [[MCRecipe alloc]init];
                    recipe.id = [obj[@"id"]integerValue];
                    vc.recipe = recipe;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if([obj[@"type"]integerValue] == 0) {
                    MCHealthDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCHealthDetailViewController"];
                    [vc setShowMsg:^(NSString * msg) {
                        [self.view makeToast:@"成功加入菜篮" duration:2 position:@"center"];
                    }];
                    MCHealth* health = [[MCHealth alloc]init];
                    health.id = [obj[@"id"]integerValue];
                    health.name = obj[@"name"];
                    vc.health = health;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else {
                
            }
        }
    } else {
        flag = true;
        [self.searchDisplayController setActive:YES animated:YES];
        self.searchDisplayController.searchBar.text = self.hotWords[indexPath.row];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if(!flag) {
            //建议结果
            return 32;
        }else{
            //搜索结果
            return 64;
        }
    } else {
        return 32;
    }

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if(!flag) {
            return @"";
        }else{
            return @"搜索结果";
        }
        
    } else {
        return @"热门词汇";
    }
}



#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    searchKey = searchText;
    if(!flag) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(searchText == Nil|| [searchText isEqualToString:@""]) {
            
            }else {
                self.suggestData = [[MCVegetableManager getInstance]getSuggestResultByKeywords:searchText Quantity:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchDisplayController.searchResultsTableView reloadData];
                });
            }
           
            
        });
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.filterData = [[MCVegetableManager getInstance]getSearchResultByKeywords:searchText Quantity:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchDisplayController.searchResultsTableView reloadData];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }
    
}


#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // 当用户改变搜索字符串时，让列表的数据来源重新加载数据
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // 返回YES，让table view重新加载。
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // 返回YES，让table view重新加载。
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    flag = false;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    flag = true;
    [self.searchDisplayController setActive:YES animated:YES];
    self.searchDisplayController.searchBar.text = searchKey;
}

#pragma mark - others
-(void)backBtnAction
{
   [self.navigationController popViewControllerAnimated:YES];
}

@end
