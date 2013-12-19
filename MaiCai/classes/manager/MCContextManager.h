//
//  MCContextManager.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-14.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString* MC_CONTEXT_POSITION;
extern const NSString* MC_USER;
extern const NSString* MC_MAC_ID;
extern const NSString* MC_PAY_NO ;

@interface MCContextManager : NSObject

+(MCContextManager*)getInstance;
-(void)addKey:(NSString*)key Data:(NSObject*)data;
-(NSObject*)getDataByKey:(NSString*)key;
-(void)setLogged:(BOOL)value;
-(BOOL)isLogged;
@end
