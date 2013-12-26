//
//  MCNetWorkObject.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-26.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCNetWorkObject : NSObject<NSCoding>
@property NSString* expire;
@property NSData* data;
@end
