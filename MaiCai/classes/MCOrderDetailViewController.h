//
//  MCOrderDetailViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
@class  MCOrder;

@interface MCOrderDetailViewController : MCBaseNavViewController<UITableViewDataSource,UITableViewDelegate>
@property MCOrder* order;
@property NSString* pay_no;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payBtnAction:(id)sender;
@end
