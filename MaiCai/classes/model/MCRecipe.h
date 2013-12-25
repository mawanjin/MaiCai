//
//  MCRecipe.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCRecipe : NSObject
@property int id;
@property NSString* name;
@property NSString* image;
@property NSString* bigImage;
@property NSString* introduction;
@property NSString* tags;
@property BOOL isMainIngredientsAllSelected;
@property BOOL isAccessoryIngredientsAllSelected;
@property NSMutableArray* mainIngredients;
@property NSMutableArray* accessoryIngredients;
@end
