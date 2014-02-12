//
//  MCOrder.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCOrder.h"
#import "DDLogConfig.h"

@implementation MCOrder

- (id)init
{
    self = [super init];
    if (self) {
        DDLogDebug(@"mcorder init");
    }
    return self;
}

- (void)dealloc
{
    DDLogDebug(@"mcorder dealloc");
}

@end
