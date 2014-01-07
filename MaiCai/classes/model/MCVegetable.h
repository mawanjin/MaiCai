//
//  MCVegetable.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-3.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCShop;
@class MCRecipe;

@interface MCVegetable : NSObject
@property  unsigned int id;
@property  NSString* name;
@property  unsigned int product_id;
@property  unsigned int shop_product_id;
@property  float price;
@property  float originalPrice;
@property  MCShop* shop;
@property  NSString* unit;
@property  NSString* dosage;
@property  NSMutableArray* recipes;
@property  unsigned int quantity;
@property BOOL isSelected;
@end
