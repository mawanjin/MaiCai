//
//  MCAddress.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-11.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCAddress : NSObject<NSCoding>
@property unsigned int id;
@property NSString* mobile;
@property NSString* address;
@property NSString* name;
@property NSString* shipper;
@end
