
//
//  MCUser.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCUser.h"

@implementation MCUser

- (id)init
{
    self = [super init];
    if (self) {
        MCLog(@"mcuser init");
    }
    return self;
}

- (void)dealloc
{
    MCLog(@"mcuser dealloc");
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[[NSString alloc]initWithFormat:@"%d",self.id] forKey:@"id"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.defaultAddress forKey:@"defaultAddress"];
    
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self.id = [[decoder decodeObjectForKey:@"id"]integerValue];
    self.userId = [decoder decodeObjectForKey:@"userId"];
    self.password = [decoder decodeObjectForKey:@"password"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.image = [decoder decodeObjectForKey:@"image"];
    self.defaultAddress = [decoder decodeObjectForKey:@"defaultAddress"];
    return self;
}

@end
