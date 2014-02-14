//
//  MCOrderConfirmViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
@class MCOrderConfirmHeader_;
@class MCAddress;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@interface MCOrderConfirmViewController :MCBaseNavViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *paymentBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,assign) SEL result;

@property unsigned int paymentMethod;
@property unsigned int shipMethod;

@property MCAddress* address;
//address列表的第几个
@property int index;
@property NSString* pay_no;
@property MCOrderConfirmHeader_* header_;
@property NSString* review;


@property NSMutableArray* data;
@property float totalPrice;
@property (nonatomic,strong)void(^showMsg)(NSString* msg);

@property NSString* reviewContent;

-(NSString*)doRsa:(NSString*)orderInfo;
- (IBAction)submitOrderAction:(id)sender;
@end
