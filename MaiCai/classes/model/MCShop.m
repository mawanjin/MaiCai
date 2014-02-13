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

-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[[NSString alloc]initWithFormat:@"%d",self.id] forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:[NSNumber numberWithInt:self.star] forKey:@"star"];
    [encoder encodeObject:self.market forKey:@"market"];
    [encoder encodeObject:self.vegetables forKey:@"vegetables"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.license forKey:@"license"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isSelected]forKey:@"isSelected"];
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self.id = [[decoder decodeObjectForKey:@"id"]integerValue];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.star = [[decoder decodeObjectForKey:@"star"]integerValue];
    self.market = [decoder decodeObjectForKey:@"market"];
    self.vegetables = [decoder decodeObjectForKey:@"vegetables"];
    self.image = [decoder decodeObjectForKey:@"image"];
    self.license = [decoder decodeObjectForKey:@"license"];
    self.isSelected = [[decoder decodeObjectForKey:@"isSelected"]boolValue];
    return self;
}


@end
