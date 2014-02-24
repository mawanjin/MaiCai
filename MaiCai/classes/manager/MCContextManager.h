//
//  MCContextManager.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-14.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MCContextManager : NSObject

+(MCContextManager*)getInstance;
-(void)addKey:(NSString*)key Data:(NSObject*)data;
-(NSObject*)getDataByKey:(NSString*)key;
-(void)setLogged:(BOOL)value;
-(BOOL)isLogged;
-(BOOL)submitErrorMessage:(NSString*) errorMessage;
- (BOOL)isMobileNumber:(NSString *)mobileNum;
- (BOOL) isBlankString:(NSString *)string;
- (BOOL) validatePassword:(NSString *)passWord;
@end
