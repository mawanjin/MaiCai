//
//  MCBaseTabViewController.m
//  MaiCai
//
//  Created by Peng Jack on 14-2-10.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCBaseTabViewController.h"

@interface MCBaseTabViewController ()

@end

@implementation MCBaseTabViewController
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
	// Do any additional setup after loading the view.
    
    //设置Navigation Bar背景图片
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setBarTintColor:[UIColor colorWithRed:0.33f green:0.71f blue:0.06f alpha:1.00f]];
    
    //navbar字体
    [navBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    //设置tabbar背景
    //    [self.tabBarController.tabBar setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f]];
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    self.tabBarController.tabBar.translucent = NO;
    
    //view背景
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
