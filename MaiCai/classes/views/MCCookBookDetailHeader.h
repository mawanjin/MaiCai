//
//  MCCookBookDetailHeader.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-16.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCCookBookDetailHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;
+(id)initInstance;
@end
