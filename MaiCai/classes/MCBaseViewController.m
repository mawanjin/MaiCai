//
//  MCBaseViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-1.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCBaseViewController.h"
#import "MCAppDelegate.h"
#import "SVProgressHUD.h"
#import "DDLogConfig.h"


NSString* const MC_ERROR_MSG_0001 = @"操作失败...";
NSString* const MC_ERROR_MSG_0002 = @"请填写收货人姓名";
NSString* const MC_ERROR_MSG_0003 = @"请填写收货人联系电话";
NSString* const MC_ERROR_MSG_0004 = @"请填写收货人地址";

@implementation MCBaseViewController
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
       
}


-(void)viewDidAppear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DDLogDebug(@"%@ dealloc",[self class]);
}

#pragma mark- others
-(void)showMsgHint:(NSString*)msg;
{
    
    [self.view makeToast:msg duration:1 position:@"center"];
    
}


-(void)showProgressHUD
{
    [SVProgressHUD showWithStatus:@"努力加载中..." maskType: SVProgressHUDMaskTypeClear];
}

-(void)hideProgressHUD
{
    [SVProgressHUD dismiss];
}


- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = YES;
    
}


- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    UIView *contentView;
    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    
    else
        
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.tabBarController.tabBar.hidden = NO;
    
}

@end
