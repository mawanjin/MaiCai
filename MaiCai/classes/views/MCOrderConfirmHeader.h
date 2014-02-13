//
//  MCOrderConfirmHeader.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCButton.h"

@interface MCOrderConfirmHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet MCButton *button;
+(id)initInstance;
@end
