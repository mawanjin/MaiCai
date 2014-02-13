//
//  MCQuickOrderHeader.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCButton.h"
@interface MCQuickOrderHeader : UIView
@property int section;
@property (weak, nonatomic) MCButton  *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
+(id)initInstance;
@end
