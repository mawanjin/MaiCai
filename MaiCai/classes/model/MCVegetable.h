//
//  MCVegetable.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-3.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCShop;

@interface MCVegetable : NSObject
@property  unsigned int id;
@property  NSString* name;
@property  unsigned int product_id;
@property  unsigned int shop_product_id;
@property  float price;
@property  MCShop* shop;
@property  NSString* unit;
@property  unsigned int quantity;
@property BOOL isSelected;
@end
