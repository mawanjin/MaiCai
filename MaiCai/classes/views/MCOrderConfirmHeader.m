//
//  MCOrderConfirmHeader.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCOrderConfirmHeader.h"
#import "MCMineAddressViewController.h"

@implementation MCOrderConfirmHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(id)initInstance
{
    MCOrderConfirmHeader* view = [[[NSBundle mainBundle]loadNibNamed:@"MCOrderConfirmHeader" owner:self options:nil]lastObject];
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
