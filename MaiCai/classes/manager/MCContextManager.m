//
//  MCContextManager.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-14.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCContextManager.h"
#import "MCNetwork.h"
#import "MCJsonParser.h"


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
    __block BOOL flag = false;
    
    NSString* url = [[NSString alloc]initWithFormat:@"%@maicai/mobile/client/log.do",MC_BASE_URL];
    
    [[MCNetwork getInstance]httpPostSynUrl:url Params:params Cache:NO Complete:^(NSURLRequest *request, MCResponse *response, NSData *data) {
        if (data && response.statusCode == 200) {
            NSError *error;
            NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            flag = [responseData[@"success"]boolValue];
            MCLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }];
    return flag;
}
@end
