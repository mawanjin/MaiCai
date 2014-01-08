//
//  MCHealth.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-30.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCHealth : NSObject
@property unsigned int id;
@property NSString* name;
@property NSString* image;
@property NSString* bigImage;
@property NSString* introduction;
@property NSMutableArray* items;
@property NSMutableArray* products;
@end
