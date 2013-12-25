//
//  MCQuickOrderViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
@class MCRecipe;

@interface MCQuickOrderViewController : MCBaseNavViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property MCRecipe* recipe;
@property BOOL isTotalChoosed;
@property (weak, nonatomic) IBOutlet UIButton *totalChooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
-(void)calculateTotalPrice;
-(void)dispLayTotalChoosedBtn;
- (IBAction)totalChooseAction:(id)sender;
-(void)resetTotalChooseBtn;
@end
