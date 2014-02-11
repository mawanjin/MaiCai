//
//  MCUser.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCAddress;

@interface MCUser : NSObject<NSCoding>
@property int id;
@property NSString* userId;
@property NSString* password;
@property NSString* name;
@property NSString* image;
@property MCAddress* defaultAddress;
@end
