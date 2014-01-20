//
//  MCContextManager.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-14.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

extern  NSString* const MC_CONTEXT_POSITION;
extern  NSString* const MC_USER;
extern  NSString* const MC_MAC_ID;
extern  NSString* const MC_PAY_NO;

@interface MCContextManager : NSObject

+(MCContextManager*)getInstance;
-(void)addKey:(NSString*)key Data:(NSObject*)data;
-(NSObject*)getDataByKey:(NSString*)key;
-(void)setLogged:(BOOL)value;
-(BOOL)isLogged;
@end
