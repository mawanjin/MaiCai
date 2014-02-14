//
//  MCOrderConfirmPayCell.h
//  MaiCai
//
//  Created by Peng Jack on 14-2-13.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCButton.h"
@interface MCOrderConfirmPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MCButton *alipayBtn;
@property (weak, nonatomic) IBOutlet MCButton *cashpayBtn;
@end
