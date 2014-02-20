//
//  MCHealth.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-30.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCHealth.h"


@implementation MCHealth
- (id)init
{
    self = [super init];
    if (self) {
        MCLog(@"mchealth init");
    }
    return self;
}

- (void)dealloc
{
    MCLog(@"mchealth dealloc");
}
@end
