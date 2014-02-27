//
//  MCCartTableViewHeader.h
//  MaiCai
//
//  Created by Peng Jack on 14-2-25.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCButton.h"

@interface MCCartTableViewHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet MCButton *button;
@property (weak, nonatomic) IBOutlet UIView *noticeView;
+(id)initInstance;
@end
