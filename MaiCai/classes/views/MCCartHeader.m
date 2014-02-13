//
//  MCCartHeader.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-17.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCCartHeader.h"
#import "MCShop.h"
#import "MCVegetable.h"
#import "MCMineCartViewController.h"

@implementation MCCartHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(id)initMCCartHeader
{
    NSArray* objs = [[NSBundle mainBundle] loadNibNamed:@"MCCartHeader" owner:self options:nil];
    MCCartHeader* obj = objs[0];
    return obj;
}

@end
