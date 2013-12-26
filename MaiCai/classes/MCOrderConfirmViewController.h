//
//  MCOrderConfirmViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
@class MCMineCartViewController;
@class MCOrderConfirmHeader_;
@class MCAddress;


@interface MCOrderConfirmViewController :MCBaseNavViewController<UITableViewDataSource,UITableViewDelegate>
@property MCMineCartViewController* previousView;
@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;

@property MCAddress* address;
//address列表的第几个
@property int index;

@property NSMutableArray* data;
@property NSString* pay_no;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property MCOrderConfirmHeader_* header_;
@property (nonatomic,assign) SEL result;
@property unsigned int paymentMethod;
@property unsigned int shipMethod;
-(NSString*)doRsa:(NSString*)orderInfo;
-(void)initData;
- (IBAction)submitOrderAction:(id)sender;
@end
