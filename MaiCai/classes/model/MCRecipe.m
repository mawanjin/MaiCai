//
//  MCRecipe.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCRecipe.h"
#import "DDLogConfig.h"

@implementation MCRecipe
- (id)init
{
    self = [super init];
    if (self) {
        DDLogDebug(@"mcrecipe init");
    }
    return self;
}

- (void)dealloc
{
    DDLogDebug(@"mcrecipe dealloc");
}
@end
