//
//  MCNetwork.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-2.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCNetwork : NSObject
+(MCNetwork*)getInstance;
-(NSData*) httpGetSynUrl:(NSString*)httpUrl Params:(NSMutableDictionary*)params Cache:(BOOL)flag;
-(NSData*) httpPostSynUrl:(NSString*)httpUrl Params:(NSMutableDictionary*)params;
-(UIImage*) loadImageFromSource:(NSString*)url;
-(void)clearCache;
- (NSString *)sizeCache;
@end
