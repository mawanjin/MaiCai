//
//  MCHealthDetailViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-31.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCHealthDetailViewController.h"
#import "UILabel+MCAutoResize.h"
#import "MCVegetableManager.h"
#import "MCHealth.h"
#import "UIImageView+MCAsynLoadImage.h"
#import "MCNetwork.h"

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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         self.health = [[MCVegetableManager getInstance]getHealthDetailById:self.health.id];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.scrollView.scrollEnabled = YES;
            UIImageView* bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 0, 250, 100)];
            [bigImageView loadImageByUrl:self.health.bigImage];
            [self.scrollView addSubview:bigImageView];
            
            UILabel* introduction = [[UILabel alloc]init];
            [introduction autoResizeByText:self.health.introduction PositionX:0.0 PositionY:bigImageView.frame.size.height];
            [self.scrollView addSubview:introduction];
            
            NSMutableArray* items = self.health.items;
            
            unsigned int height = bigImageView.frame.size.height+introduction.frame.size.height;
            
            for(int i=0;i<items.count;i++) {
                NSDictionary* item = items[i];
                
                UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35,height, 250, 100)];
                [imageView loadImageByUrl:item[@"image"]];
                [self.scrollView addSubview:imageView];
                height = height+imageView.frame.size.height;
                
                UILabel* label = [[UILabel alloc]init];
                [label autoResizeByText:item[@"content"] PositionX:0 PositionY:height];
                [self.scrollView addSubview:label];
                height = height+label.frame.size.height;
            }
            
            //[[UICollectionView alloc]INITW]
            
             self.scrollView.contentSize = CGSizeMake(320,height);
        });
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
