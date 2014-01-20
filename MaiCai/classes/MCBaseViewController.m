//
//  MCBaseViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-1.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCBaseViewController.h"
#import "MCAppDelegate.h"


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
    
    //设置Navigation Bar背景图片
    UINavigationBar *navBar = self.navigationController.navigationBar;
   [navBar setBarTintColor:[UIColor colorWithRed:0.33f green:0.71f blue:0.06f alpha:1.00f]];

    //navbar字体
    [navBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    //设置tabbar背景
    
//    [self.tabBarController.tabBar setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f]];
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    self.tabBarController.tabBar.translucent = NO;
    
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


-(void)showMsgHint:(NSString*)msg
{
    [self.view makeToast:msg duration:2 position:@"center"];
}







@end
