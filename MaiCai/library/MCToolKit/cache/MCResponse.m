//
//  MCResponse.m
//  MCToolKit
//
//  Created by Peng Jack on 14-3-10.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCResponse.h"

@implementation MCResponse

-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithInt:self.statusCode] forKey:@"statusCode"];
    [encoder encodeObject:self.fields forKey:@"fields"];
    [encoder encodeObject:self.data forKey:@"data"];
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self.statusCode = [[decoder decodeObjectForKey:@"statusCode"]integerValue];
    self.fields = [decoder decodeObjectForKey:@"fields"];
    self.data = [decoder decodeObjectForKey:@"data"];
    return self;
}

@end
