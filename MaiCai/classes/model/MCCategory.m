//
//  MCCategory.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-14.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCCategory.h"


@implementation MCCategory
- (id)init
{
    self = [super init];
    if (self) {
        MCLog(@"mccategory init");
    }
    return self;
}

- (void)dealloc
{
    MCLog(@"mccategory dealloc");
}
@end
