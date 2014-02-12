//
//  MCStep.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCStep.h"
#import "DDLogConfig.h"

@implementation MCStep
- (id)init
{
    self = [super init];
    if (self) {
        DDLogDebug(@"mcstep init");
    }
    return self;
}

- (void)dealloc
{
    DDLogDebug(@"mcstep dealloc");
}
@end
