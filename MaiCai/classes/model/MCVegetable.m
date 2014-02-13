//
//  MCVegetable.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-3.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//



#import "MCVegetable.h"
#import "DDLogConfig.h"



@implementation MCVegetable
- (id)init
{
    self = [super init];
    if (self) {
        DDLogDebug(@"mcvegetable init");
    }
    return self;
}

- (void)dealloc
{
    DDLogDebug(@"mcvegetable dealloc");
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[[NSString alloc]initWithFormat:@"%d",self.id] forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:[NSNumber numberWithInt:self.product_id] forKey:@"product_id"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:[NSNumber numberWithInt:self.shop_product_id] forKey:@"shop_product_id"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.price] forKey:@"price"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.originalPrice] forKey:@"originalPrice"];
    [encoder encodeObject:self.shop forKey:@"shop"];
    [encoder encodeObject:self.unit forKey:@"unit"];
    [encoder encodeObject:self.dosage forKey:@"dosage"];
    [encoder encodeObject:self.recipes forKey:@"recipes"];
    [encoder encodeObject:[NSNumber numberWithInt:self.quantity ]forKey:@"quantity"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isSelected] forKey:@"isSelected"];
    
    
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self.id = [[decoder decodeObjectForKey:@"id"]integerValue];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.name = [decoder decodeObjectForKey:@"product_id"];
    self.name = [decoder decodeObjectForKey:@"image"];
    self.name = [decoder decodeObjectForKey:@"shop_product_id"];
    self.name = [decoder decodeObjectForKey:@"price"];
    self.name = [decoder decodeObjectForKey:@"originalPrice"];
    self.name = [decoder decodeObjectForKey:@"shop"];
    self.name = [decoder decodeObjectForKey:@"unit"];
    self.name = [decoder decodeObjectForKey:@"dosage"];
    self.name = [decoder decodeObjectForKey:@"recipes"];
    self.name = [decoder decodeObjectForKey:@"quantity"];
    self.name = [decoder decodeObjectForKey:@"isSelected"];
    
    return self;
}

@end
