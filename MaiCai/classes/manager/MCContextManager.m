//
//  MCContextManager.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-14.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCContextManager.h"

NSString* const MC_CONTEXT_POSITION = @"position";
NSString* const MC_USER = @"user";
NSString* const MC_MAC_ID = @"macId";
NSString* const MC_PAY_NO = @"payNo";


@implementation MCContextManager
static MCContextManager* instance;
NSMutableDictionary* dictionary;
bool isLogged;


+(MCContextManager*)getInstance
{
    @synchronized (self){
        if (instance == nil) {
            instance = [[MCContextManager alloc] init];
            dictionary = [[NSMutableDictionary alloc]init];
        }
    }
    return instance;
}

-(void)addKey:(NSString*)key Data:(NSObject*)data
{
    [dictionary setObject:data forKey:key];
}

-(NSObject*)getDataByKey:(NSString*)key;
{
    return dictionary[key];
}

-(BOOL)isLogged
{
    return isLogged;
}

-(void)setLogged:(BOOL)value
{
    isLogged = value;
}

@end
