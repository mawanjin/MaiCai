//
//  MCContextManager.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-14.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCContextManager.h"
#import "MCNetwork.h"

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

-(BOOL)submitErrorMessage:(NSString*) errorMessage
{
    NSDictionary* params = @{
                             @"content":errorMessage,
                             @"log_type":@"4"
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/mobile/client/log.do" Params:data];
    if (result == nil) {
        return false;
    }
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    return flag;
}

@end
