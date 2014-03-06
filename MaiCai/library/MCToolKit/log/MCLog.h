//
//  MCLog.h
//  MaiCai
//
//  Created by Peng Jack on 14-2-20.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#   define MCLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define MCLog(...)
#endif

@interface MCLog : NSObject

@end
