//
//  MCShop.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-7.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCShop.h"
#import "DDLogConfig.h"

@implementation MCShop

- (id)init
{
    self = [super init];
    if (self) {
        DDLogDebug(@"mcshop init");
    }
    return self;
}

- (void)dealloc
{
    DDLogDebug(@"mcshop dealloc");
}

@end
