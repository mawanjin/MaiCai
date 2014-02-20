//
//  MCMarket.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-4.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMarket.h"

@implementation MCMarket

- (id)init
{
    self = [super init];
    if (self) {
        MCLog(@"mcmarket init");
    }
    return self;
}

- (void)dealloc
{
    MCLog(@"mcmarket dealloc");
}


-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[[NSString alloc]initWithFormat:@"%d",self.id] forKey:@"id"];
    [encoder encodeObject:self.distance forKey:@"distance"];
    [encoder encodeObject:self.name forKey:@"name"];
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self.id = [[decoder decodeObjectForKey:@"id"]integerValue];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.distance = [decoder decodeObjectForKey:@"distance"];
    return self;
}


@end
