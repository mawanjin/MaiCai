//
//  MCCartTableViewHeader.m
//  MaiCai
//
//  Created by Peng Jack on 14-2-25.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCCartTableViewHeader.h"

@implementation MCCartTableViewHeader

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
    MCCartTableViewHeader* view = [[[NSBundle mainBundle]loadNibNamed:@"MCCartTableViewHeader" owner:self options:Nil]lastObject];
    return view;
}

@end
