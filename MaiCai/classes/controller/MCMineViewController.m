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
#import "MCFeedbackViewController.h"
#import "MCMineCell.h"
#import "MCMineFooter.h"
#import "MCNetwork.h"
#import "MCUserManager.h"
#import "MCSettingViewController.h"



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
    [footer.btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
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
        MCMineCartViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCMineCartViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc  animated:YES];
    }else if(indexPath.row == 1) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            MCMineOrderViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCMineOrderViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc  animated:YES];
        }else{
            
        }

    }else if(indexPath.row == 2) {
        
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            MCMineAddressViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCMineCollectViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc  animated:YES];
        }else{
            
        }
        
    }else if(indexPath.row == 3) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            MCMineAddressViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCMineAddressViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc  animated:YES];
        }else{
            
        }

    }else if(indexPath.row == 4) {
        MCFeedbackViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCFeedbackViewController"];
        [vc setSubmitComplete:^{
            [self showMsgHint:@"提交成功"];
        }];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc  animated:YES];

    }else if(indexPath.row == 5) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            MCPersonalInfoViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCPersonalInfoViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc  animated:YES];
        }else{
            
        }
    }else if(indexPath.row == 6) {
        MCSettingViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCSettingViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc  animated:YES];
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
            cell.label.textColor = [UIColor blackColor];
        }else {
            cell.image.image = [UIImage imageNamed:@"mine_order_grey"];
            cell.label.textColor = [UIColor grayColor];
        }
        cell.label.text = @"我的订单";
    }else if(indexPath.row == 2) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            cell.image.image = [UIImage imageNamed:@"mine_cookbook_normal"];
            cell.label.textColor = [UIColor blackColor];
        }else {
            cell.image.image = [UIImage imageNamed:@"mine_cookbook_grey"];
            cell.label.textColor = [UIColor grayColor];
        }
        cell.label.text = @"我的收藏";
    }else if(indexPath.row == 3) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            cell.image.image = [UIImage imageNamed:@"mine_address_normal"];
            cell.label.textColor = [UIColor blackColor];
        }else {
            cell.image.image = [UIImage imageNamed:@"mine_address_grey"];
            cell.label.textColor = [UIColor grayColor];
        }
        cell.label.text = @"收货地址";
    }else if(indexPath.row == 4) {
        cell.image.image = [UIImage imageNamed:@"mine_opinion_normal"];
        cell.label.text = @"意见反馈";
    }else if(indexPath.row == 5) {
        BOOL isLoged = [[MCContextManager getInstance]isLogged];
        if(isLoged) {
            cell.image.image = [UIImage imageNamed:@"mine_personal_normal"];
            cell.label.textColor = [UIColor blackColor];
        }else {
            cell.image.image = [UIImage imageNamed:@"mine_personal_grey"];
            cell.label.textColor = [UIColor grayColor];
        }
        cell.label.text = @"个人信息";
        
    }else if(indexPath.row == 6) {
        cell.image.image = [UIImage imageNamed:@"mine_setting_normal"];
        cell.label.text = @"系统设置";
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
    MCPersonalInfoViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCPersonalInfoViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc  animated:YES];
}

- (IBAction)clickAction:(UIButton *)sender {
    BOOL isLoged = [[MCContextManager getInstance]isLogged];
    
    if(isLoged) {
        UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"确定需要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else {
        MCLoginViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCLoginViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[MCUserManager getInstance]clearLoginStatus];
        [[MCContextManager getInstance]setLogged:NO];
        [self viewWillAppear:YES];
        
    }else{
        return;
    }
}

@end
