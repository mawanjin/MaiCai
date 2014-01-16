//
//  MCBaseNavViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-7.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCBaseNavViewController.h"

@implementation MCBaseNavViewController

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
    UIBarButtonItem* item = [[UIBarButtonItem alloc]
                             init];
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 12, 20)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [item setCustomView:backBtn];
    self.navigationItem.leftBarButtonItem= item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
