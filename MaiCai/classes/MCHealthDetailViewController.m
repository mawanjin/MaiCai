//
//  MCHealthDetailViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-31.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCHealthDetailViewController.h"
#import "UILabel+MCAutoResize.h"

@interface MCHealthDetailViewController ()

@end

@implementation MCHealthDetailViewController

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

    
    UILabel* label = [[UILabel alloc]init];
    
    //[label autoResizeByText:text PositionX:0.0 PositionY:40.0];
    [self.view addSubview:label];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
