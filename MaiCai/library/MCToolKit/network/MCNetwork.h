//
//  MCNetwork.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-2.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCUrlCache.h"

typedef void(^completeBlock)(NSURLRequest* request,MCResponse* response,NSData* data);

@interface MCNetwork : NSObject
+(MCNetwork*)getInstance;
-(void) httpGetSynUrl:(NSString*)httpUrl Params:(NSDictionary*)params Cache:(BOOL)cache Complete:(completeBlock)completeBlock;
-(void) httpPostSynUrl:(NSString*)httpUrl Params:(NSDictionary*)params Cache:(BOOL)cache Complete:(completeBlock)completeBlock;
-(void) httpDeleteSynUrl:(NSString*)httpUrl Params:(NSDictionary*)params Cache:(BOOL)cache Complete:(completeBlock)completeBlock;
-(void) httpPutSynUrl:(NSString*)httpUrl Params:(NSDictionary*)params Cache:(BOOL)cache Complete:(completeBlock)completeBlock;
-(UIImage*) loadImageFromSource:(NSString*)url;
@end
