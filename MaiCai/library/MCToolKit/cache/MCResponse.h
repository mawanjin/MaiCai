//
//  MCResponse.h
//  MCToolKit
//
//  Created by Peng Jack on 14-3-10.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCResponse : NSObject<NSCoding>
@property unsigned int statusCode;
@property NSMutableDictionary* fields;
@property NSData* data;
@end
