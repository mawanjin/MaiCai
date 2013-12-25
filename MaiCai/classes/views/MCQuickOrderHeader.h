//
//  MCQuickOrderHeader.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCQuickOrderViewController;

@interface MCQuickOrderHeader : UIView

@property int section;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property MCQuickOrderViewController* parentView;
+(id)initInstance;
- (IBAction)chooseBtnClickAction:(UIButton *)sender;
@end
