//
//  MCTipsHeader.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-23.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCMarketIndexTipsHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsLabel;
+(id)initInstance;
@end
