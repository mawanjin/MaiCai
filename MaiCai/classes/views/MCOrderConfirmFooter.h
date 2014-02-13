//
//  MCOrderConfirmFooter.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-26.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCButton.h"
@interface MCOrderConfirmFooter : UIView
@property (weak, nonatomic) IBOutlet MCButton *alipayBtn;
@property (weak, nonatomic) IBOutlet MCButton *cashpayBtn;
@property (weak, nonatomic) IBOutlet MCButton *deliveryToHomeBtn;
@property (weak, nonatomic) IBOutlet UITextField *reviewTextField;
@property (weak, nonatomic) IBOutlet MCButton *getBySelfBtn;
+(id)initInstance;
@end
