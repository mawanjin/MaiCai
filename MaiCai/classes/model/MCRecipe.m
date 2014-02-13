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


-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[[NSString alloc]initWithFormat:@"%d",self.id] forKey:@"id"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.bigImage forKey:@"bigImage"];
    [encoder encodeObject:self.introduction forKey:@"introduction"];
    [encoder encodeObject:self.dosage forKey:@"dosage"];
    [encoder encodeObject:self.tags forKey:@"tags"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isMainIngredientsAllSelected] forKey:@"isMainIngredientsAllSelected"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isAccessoryIngredientsAllSelected] forKey:@"isAccessoryIngredientsAllSelected"];
    [encoder encodeObject:self.mainIngredients forKey:@"mainIngredients"];
    [encoder encodeObject:self.accessoryIngredients forKey:@"accessoryIngredients"];
    [encoder encodeObject:self.steps forKey:@"steps"];
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self.id = [[decoder decodeObjectForKey:@"id"]integerValue];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.image = [decoder decodeObjectForKey:@"image"];
    self.bigImage = [decoder decodeObjectForKey:@"bigImage"];
    self.introduction = [decoder decodeObjectForKey:@"introduction"];
    self.dosage = [decoder decodeObjectForKey:@"dosage"];
    self.tags = [decoder decodeObjectForKey:@"tags"];
    self.isMainIngredientsAllSelected = [[decoder decodeObjectForKey:@"isMainIngredientsAllSelected"]boolValue];
    self.isAccessoryIngredientsAllSelected = [[decoder decodeObjectForKey:@"isAccessoryIngredientsAllSelected"]boolValue];
    self.mainIngredients = [decoder decodeObjectForKey:@"mainIngredients"];
    self.accessoryIngredients = [decoder decodeObjectForKey:@"accessoryIngredients"];
    self.steps = [decoder decodeObjectForKey:@"steps"];
    return self;
}

@end
