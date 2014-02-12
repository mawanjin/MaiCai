//
//  MCMarket.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-4.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMarket.h"
#import "DDLogConfig.h"

@implementation MCMarket

- (id)init
{
    self = [super init];
    if (self) {
        DDLogDebug(@"mcmarket init");
    }
    return self;
}

- (void)dealloc
{
    DDLogDebug(@"mcmarket dealloc");
}

@end
