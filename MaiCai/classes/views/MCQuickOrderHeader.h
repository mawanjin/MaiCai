//
//  MCQuickOrderHeader.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCQuickOrderHeader : UIView
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property UIViewController* parentViewController;
+(id)initInstance;
@end
