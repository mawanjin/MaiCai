//
//  MCBaseViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-1.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCBaseViewController.h"
#import "MCAppDelegate.h"



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


-(BOOL)netWorkIsReachable {
    MCAppDelegate* appDlg = [[UIApplication sharedApplication]delegate];
    if(appDlg.isReachable)
    {
        NSLog(@"网络已连接");//执行网络正常时的代码
    }
    else
    {
        NSLog(@"网络连接异常");//执行网络异常时的代码
    }
    return appDlg.isReachable;
}


@end
