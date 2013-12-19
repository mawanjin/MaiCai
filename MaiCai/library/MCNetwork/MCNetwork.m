//
//  MCNetwork.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-2.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCNetwork.h"
#import "NSString+MD5Addition.h"


@implementation MCNetwork
static MCNetwork* instance;

+(MCNetwork*)getInstance
{
    @synchronized (self){
        if (instance == nil) {
            instance = [[MCNetwork alloc] init];
        }
    }
    return instance;
}


-(NSData*) httpGetSynUrl:(NSString*)httpUrl Params:(NSMutableDictionary*)params
{
    NSString *urlAsString = httpUrl;
    int count = 1;
    for (NSString* key in [params allKeys]){
        NSString* value = [params objectForKey:key];
        if(count == 1)
            urlAsString = [urlAsString stringByAppendingFormat:@"?%@=%@",key,value];
        else
            urlAsString = [urlAsString stringByAppendingFormat:@"&%@=%@",key,value];
        count++;
    }

    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *currentTime = [NSString stringWithFormat:@"%.0f", a];
    NSString * path = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@.txt",[urlAsString stringFromMD5]]];
    NSError* error;
    NSData* data = [[NSData alloc]initWithContentsOfFile:path];
    
    //如何有缓存，并且没有过有效期
    if(data != nil) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSString* expires = dic[@"Expires"];
        if([currentTime longLongValue]<[expires longLongValue]) {
            return data;
        }
    }
    
    //否则就从网上拉取
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse *response;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        // 取得http状态码
         NSLog(@"此次请求状态码是%ld",(long)[response statusCode]);
        if((long)[response statusCode] != 200) {
            @throw [[NSException alloc]initWithName:@"错误" reason:@"状态码不是200" userInfo:nil];
        }
       
        // 取得所有的请求的头
        NSDictionary *dictionary = [response allHeaderFields];
        NSString* expires = dictionary[@"Expires"];
        dictionary = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
        NSMutableDictionary* temp = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
        [temp setValue:expires forKey:@"Expires"];
        
        NSData* temp1 = [NSJSONSerialization dataWithJSONObject:temp options:NSJSONReadingAllowFragments error:&error];
        
        [temp1 writeToFile:path atomically:YES];
    }

    return result;
}


-(NSData*) httpPostSynUrl:(NSString*)httpUrl Params:(NSMutableDictionary*)params
{
    NSString *urlAsString = httpUrl;
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *body = @"";
    int count = 1;
    for (NSString* key in [params allKeys]){
        NSString* value = [params objectForKey:key];
        if(count == 1)
            body = [body stringByAppendingFormat:@"%@=%@",key,value];
        else
            body = [body stringByAppendingFormat:@"&%@=%@",key,value];
        count++;
    }
    
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
   
    NSData *response = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    return  response;
}

-(UIImage*) loadImageFromSource:(NSString*)url
{
    //如果有缓存读缓存
    NSString * path = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@",[url stringFromMD5]]];
    NSError *error=nil;
    NSURL *u=[NSURL URLWithString:url];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:u];
    NSData *imgData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    //建立缓存
    [imgData writeToFile:path atomically:YES];
    return [UIImage imageWithData:imgData];
}
@end
