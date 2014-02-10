//
//  MCTipsHeader.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-23.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMarketIndexTipsHeader.h"

@implementation MCMarketIndexTipsHeader

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
    return [[[NSBundle mainBundle]loadNibNamed:@"MCMarketIndexTipsHeader" owner:self
                                options:Nil]lastObject];
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
