//
//  MCVegetable.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-3.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//



#import "MCVegetable.h"
#import "DDLogConfig.h"



@implementation MCVegetable
- (id)init
{
    self = [super init];
    if (self) {
        DDLogDebug(@"mcvegetable init");
    }
    return self;
}

- (void)dealloc
{
    DDLogDebug(@"mcvegetable dealloc");
}
@end
