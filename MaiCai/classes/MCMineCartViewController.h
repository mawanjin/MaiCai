//
//  MCMineCartViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-10-30.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"

@interface MCMineCartViewController : MCBaseNavViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *totalChooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;


@property float totalPrice;
@property BOOL isTotalChoosed;
@property  NSMutableArray* data;



-(void)calculateTotalPrice;
- (IBAction)totalChooseBtnClickAction:(UIButton *)sender;
-(void)dispLayTotalChoosedBtn;
- (IBAction)submitBtnAction:(UIButton *)sender;

@end
