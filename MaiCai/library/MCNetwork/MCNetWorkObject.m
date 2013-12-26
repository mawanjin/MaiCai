//
//  MCNetWorkObject.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-26.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCNetWorkObject.h"

@implementation MCNetWorkObject
-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject: self.expire forKey:@"expire"];
    [encoder encodeObject:self.data forKey:@"data"];
    
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self.expire = [decoder decodeObjectForKey:@"expire"];
    self.data = [decoder decodeObjectForKey:@"data"];
    return self;
}
@end
