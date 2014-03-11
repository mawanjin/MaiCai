//
//  MCUrlCache.h
//  MCToolKit
//
//  Created by Peng Jack on 14-3-10.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCResponse.h"

@interface MCUrlCache : NSObject

@property NSString* baseDiskPath;
@property NSString* cachePath;

+(MCUrlCache*)getInstance;
- (MCResponse *)cachedResponseForUrl:(NSString *)url;
- (void)storeResponse:(MCResponse *)response forUrl:(NSString*)url;
- (void)removeCachedResponseForUrl:(NSString *)url;
- (void)removeAllCachedResponses;
- (double)currentDiskUsage;

@end
