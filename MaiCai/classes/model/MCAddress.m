//
//  MCAddress.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-11.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCAddress.h"

@implementation MCAddress

- (id)init
{
    self = [super init];
    if (self) {
        MCLog(@"mcaddress init");
    }
    return self;
}

- (void)dealloc
{
    MCLog(@"mcaddress dealloc");
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[[NSString alloc]initWithFormat:@"%d",self.id] forKey:@"id"];
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.shipper forKey:@"shipper"];
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self.id = [[decoder decodeObjectForKey:@"id"]integerValue];
    self.mobile = [decoder decodeObjectForKey:@"mobile"];
    self.address = [decoder decodeObjectForKey:@"address"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.shipper = [decoder decodeObjectForKey:@"shipper"];
    return self;
}
@end
