//
//  MCQuickOrderHeader.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCQuickOrderHeader.h"
#import "MCQuickOrderViewController.h"
#import "MCRecipe.h"
#import "MCVegetable.h"

@implementation MCQuickOrderHeader

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

+(id)initInstance
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MCQuickOrderHeader" owner:self options:Nil]lastObject];
}

@end
