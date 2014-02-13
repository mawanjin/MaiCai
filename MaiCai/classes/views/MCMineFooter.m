//
//  MCMineFooter.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMineFooter.h"
#import "MCContextManager.h"
#import "MCLoginViewController.h"
#import "MCUserManager.h"

@implementation MCMineFooter

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
    UIView* view = [[[NSBundle mainBundle]loadNibNamed:@"MCMineFooter" owner:self options:nil]lastObject];
    return view;
}


@end
