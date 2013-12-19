//
//  MCVegetableDetailViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-5.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
@class MCVegetable;

@interface MCVegetableDetailViewController : MCBaseNavViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *healthBtn;
@property (weak, nonatomic) IBOutlet UIButton *cookBookBtn;
@property MCVegetable* vegetable;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *discoutPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *shopLabel;

- (IBAction)segementChooseAction:(id)sender;

- (IBAction)phoneCallAction:(id)sender;
- (IBAction)addProductToCartAction:(id)sender;
@end
