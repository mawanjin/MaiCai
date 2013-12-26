//
//  MCOrderDetailFooter.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCOrderDetailFooter : UIView
+(id)initInstance;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *shipMethodLabel;
@end
