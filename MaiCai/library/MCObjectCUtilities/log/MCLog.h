//
//  MCLog.h
//  MaiCai
//
//  Created by Peng Jack on 14-2-20.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define MCLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define MCLog(format, ...)
#endif

@interface MCLog : NSObject

@end
