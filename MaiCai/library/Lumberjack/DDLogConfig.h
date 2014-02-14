//
//  DDLogConfig.h
//  MaiCai
//
//  Created by Peng Jack on 14-2-12.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#endif

@interface DDLogConfig : NSObject

@end
