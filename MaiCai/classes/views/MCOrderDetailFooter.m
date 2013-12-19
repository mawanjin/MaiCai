
//
//  MCOrderDetailFooter.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCOrderDetailFooter.h"

@implementation MCOrderDetailFooter

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
    MCOrderDetailFooter* view =  [[[NSBundle mainBundle]loadNibNamed:@"MCOrderDetailFooter" owner:self options:Nil]lastObject];
    return view;
}

@end
