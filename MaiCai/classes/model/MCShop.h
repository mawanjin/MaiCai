//
//  MCShop.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-7.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCMarket;

@interface MCShop : NSObject
@property unsigned int id;
@property NSString* name;
@property unsigned int star;
@property MCMarket* market;
@property NSMutableArray* vegetables;
@property NSString* image;
@property NSString* license;
@property BOOL isSelected;

@end
