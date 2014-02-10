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


NSString* const MC_ERROR_MSG_0001 = @"操作失败...";
NSString* const MC_ERROR_MSG_0002 = @"请填写收货人姓名";
NSString* const MC_ERROR_MSG_0003 = @"请填写收货人联系电话";
NSString* const MC_ERROR_MSG_0004 = @"请填写收货人地址";

@implementation MCBaseViewController

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


-(void)showMsgHint:(NSString*)msg;
{
    
    [self.view makeToast:msg duration:1 position:@"center"];
    
}


-(void)showProgressHUD
{
    [SVProgressHUD showWithStatus:@"努力加载中..." maskType: SVProgressHUDMaskTypeGradient];
}

-(void)hideProgressHUD
{
    [SVProgressHUD dismiss];
}







@end
