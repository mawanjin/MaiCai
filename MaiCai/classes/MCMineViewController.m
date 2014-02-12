//
//  MCKitchenViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMineViewController.h"
#import "MCLoginViewController.h"
#import "MCMineAddressViewController.h"
#import "MCLoginViewController.h"
#import "MCContextManager.h"
#import "MCMineCartViewController.h"
#import "MCPersonalInfoViewController.h"
#import "MCMineOrderViewController.h"
#import "MCMineCell.h"
#import "MCMineFooter.h"
#import "MCNetwork.h"


@implementation MCMineViewController
{
    @private
        MCMineFooter* footer;
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
    footer = [MCMineFooter initInstance];
    footer.parentView = self;
    self.tableView.tableFooterView = footer;
    
}





- (void)viewWillAppear:(BOOL)animated
{
    
    BOOL isLoged = [[MCContextManager getInstance]isLogged];
    if(isLoged) {
         [footer.btn setTitle:@"退出" forState:UIControlStateNormal];
    }else {
         [footer.btn setTitle:@"登入" forState:UIControlStateNormal];
    }
   
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:nil];
        MCMineCartViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCMineCartViewController"];
        [self.navigationController pushViewController:vc  animated:YES];
    }else if(indexPath.row == 1) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                          bundle:nil];
            MCMineOrderViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCMineOrderViewController"];
            
            [self.navigationController pushViewController:vc  animated:YES];
        }else{
            
        }

    }else if(indexPath.row == 2) {
        
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                          bundle:nil];
            MCMineAddressViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCMineCollectViewController"];
            
            [self.navigationController pushViewController:vc  animated:YES];
        }else{
            
        }
        
    }else if(indexPath.row == 3) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                          bundle:nil];
            MCMineAddressViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCMineAddressViewController"];
            
            [self.navigationController pushViewController:vc  animated:YES];
        }else{
            
        }

    }else if(indexPath.row == 4) {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:nil];
        MCPersonalInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCFeedbackViewController"];
        
        [self.navigationController pushViewController:vc  animated:YES];

    }else if(indexPath.row == 5) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                          bundle:nil];
            MCPersonalInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCPersonalInfoViewController"];
            
            [self.navigationController pushViewController:vc  animated:YES];
        }else{
            
        }
        
    }else if(indexPath.row == 6) {
        [self showProgressHUD];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             [[MCNetwork getInstance]clearCache];
              dispatch_async(dispatch_get_main_queue(), ^{
                  [self hideProgressHUD];
                  [self showMsgHint:@"清空缓存成功..."];
                  [self.tableView reloadData];
              });
        });
       
        
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCMineCell* cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell"];
    if(indexPath.row == 0) {
        cell.image.image = [UIImage imageNamed:@"mine_basket_normal"];
        cell.label.text = @"我的菜篮";
    }else if(indexPath.row == 1) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            cell.image.image = [UIImage imageNamed:@"mine_order_normal"];
        }else {
            cell.image.image = [UIImage imageNamed:@"mine_order_grey"];
        }
        cell.label.text = @"我的订单";
    }else if(indexPath.row == 2) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            cell.image.image = [UIImage imageNamed:@"mine_cookbook_normal"];
        }else {
            cell.image.image = [UIImage imageNamed:@"mine_cookbook_grey"];
        }
        cell.label.text = @"我的收藏";
    }else if(indexPath.row == 3) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            cell.image.image = [UIImage imageNamed:@"mine_address_normal"];
        }else {
            cell.image.image = [UIImage imageNamed:@"mine_address_grey"];
        }
        cell.label.text = @"收货地址";
    }else if(indexPath.row == 4) {
        cell.image.image = [UIImage imageNamed:@"mine_opinion_normal"];
        cell.label.text = @"意见反馈";
    }else if(indexPath.row == 5) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            cell.image.image = [UIImage imageNamed:@"mine_personal_normal"];
        }else {
            cell.image.image = [UIImage imageNamed:@"mine_personal_grey"];
        }
        cell.label.text = @"个人信息";
    }else if(indexPath.row == 6) {
        cell.image.image = [UIImage imageNamed:@"mine_personal_normal"];
        cell.label.text = [[NSString alloc]initWithFormat:@"清除缓存(%@MB)",[[MCNetwork getInstance] sizeCache]];
        cell.divideLine.hidden = YES;
    }else{
        
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark- others
-(void)minePersonalInfoBtnAction
{
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    MCPersonalInfoViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCPersonalInfoViewController"];
    
    [self.navigationController pushViewController:vc  animated:YES];
}

@end
