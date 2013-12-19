//
//  MCOrderConfirmFooter.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-26.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCOrderConfirmViewController;
@interface MCOrderConfirmFooter : UIView
@property MCOrderConfirmViewController* parentView;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *cashpayBtn;
+(id)initInstance;
- (IBAction)chooseAction:(id)sender;


@end
