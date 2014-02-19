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
#import "Reachability.h"


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
    [self registerReachability];
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
    [SVProgressHUD showWithStatus:@"努力加载中..." maskType: SVProgressHUDMaskTypeNone];
}

-(void)hideProgressHUD
{
    [SVProgressHUD dismiss];
}


-(void)registerReachability{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self showMsgHint:@""];
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMsgHint:@"当前无网络连接！"];
        });
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

@end
