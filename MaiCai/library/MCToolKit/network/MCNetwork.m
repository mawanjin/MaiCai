//
//  MCNetwork.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-2.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCNetwork.h"
#import "MCFileOperation.h"



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


-(void) httpGetSynUrl:(NSString*)httpUrl Params:(NSDictionary*)params Cache:(BOOL)cache Complete:(completeBlock)completeBlock
{
    NSMutableString *urlAsString = [NSMutableString stringWithString:httpUrl];
    //参数处理
    int count = 1;
    if(params != nil) {
        for (NSString* key in [params allKeys]){
            NSString* value = [params objectForKey:key];
            if(count == 1)
                [urlAsString appendFormat:@"?%@=%@",key,value];
            else
                [urlAsString appendFormat:@"&%@=%@",key,value];
            count++;
        }
    }
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:15.0f];
    [urlRequest setHTTPMethod:@"GET"];

    if (cache) {
        //处理cache逻辑如果有cache就从cache中读取
        MCResponse* cacheResponse = [[MCUrlCache getInstance]cachedResponseForUrl:urlAsString];
        if (cacheResponse) {
            NSData* data = [cacheResponse data];
            completeBlock(urlRequest,cacheResponse,data);
        }else {
            NSHTTPURLResponse *response;
            NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            cacheResponse = [[MCResponse alloc]init];
            cacheResponse.data = result;
            cacheResponse.statusCode = response.statusCode;
            cacheResponse.fields = [[NSMutableDictionary alloc]initWithDictionary:response.allHeaderFields];
            [[MCUrlCache  getInstance]storeResponse:cacheResponse forUrl:urlAsString];
            completeBlock(urlRequest,cacheResponse,result);
        }
    }else {
        NSHTTPURLResponse *response;
        NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
        MCResponse* cacheResponse = [[MCResponse alloc]init];
        cacheResponse.data = result;
        cacheResponse.statusCode = response.statusCode;
        cacheResponse.fields = [[NSMutableDictionary alloc]initWithDictionary:response.allHeaderFields];
        completeBlock(urlRequest,cacheResponse,result);
    }
}

-(void) httpPostSynUrl:(NSString*)httpUrl Params:(NSDictionary*)params Cache:(BOOL)cache Complete:(completeBlock)completeBlock
{
    NSString *urlAsString = httpUrl;
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:15.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    //参数处理
    int count = 1;
    if(params != nil) {
        NSMutableString *body = [NSMutableString stringWithString:@""];
        for (NSString* key in [params allKeys]){
            NSString* value = [params objectForKey:key];
            if(count == 1)
                [body appendFormat:@"%@=%@",key,value];
            else
                [body appendFormat:@"&%@=%@",key,value];
            count++;
        }
        [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (cache) {
        //处理cache逻辑如果有cache就从cache中读取
        MCResponse* cacheResponse = [[MCUrlCache getInstance]cachedResponseForUrl:urlAsString];
        if (cacheResponse) {
            NSData* data = [cacheResponse data];
            completeBlock(urlRequest,cacheResponse,data);
        }else {
            NSHTTPURLResponse *response;
            NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            cacheResponse = [[MCResponse alloc]init];
            cacheResponse.data = result;
            cacheResponse.statusCode = response.statusCode;
            cacheResponse.fields = [[NSMutableDictionary alloc]initWithDictionary:response.allHeaderFields];
            [[MCUrlCache  getInstance]storeResponse:cacheResponse forUrl:urlAsString];
            completeBlock(urlRequest,cacheResponse,result);
        }
    }else {
        NSHTTPURLResponse *response;
        NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
        MCResponse* cacheResponse = [[MCResponse alloc]init];
        cacheResponse.data = result;
        cacheResponse.statusCode = response.statusCode;
        cacheResponse.fields = [[NSMutableDictionary alloc]initWithDictionary:response.allHeaderFields];
        completeBlock(urlRequest,cacheResponse,result);
    }
}


-(void) httpDeleteSynUrl:(NSString*)httpUrl Params:(NSDictionary*)params Cache:(BOOL)cache Complete:(completeBlock)completeBlock
{
    NSString *urlAsString = httpUrl;
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:15.0f];
    [urlRequest setHTTPMethod:@"DELETE"];
    
    //参数处理
    int count = 1;
    if(params != nil) {
        NSMutableString *body = [NSMutableString stringWithString:@""];
        for (NSString* key in [params allKeys]){
            NSString* value = [params objectForKey:key];
            if(count == 1)
                [body appendFormat:@"%@=%@",key,value];
            else
                [body appendFormat:@"&%@=%@",key,value];
            count++;
        }
        [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (cache) {
        //处理cache逻辑如果有cache就从cache中读取
        MCResponse* cacheResponse = [[MCUrlCache getInstance]cachedResponseForUrl:urlAsString];
        if (cacheResponse) {
            NSData* data = [cacheResponse data];
            completeBlock(urlRequest,cacheResponse,data);
        }else {
            NSHTTPURLResponse *response;
            NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            cacheResponse = [[MCResponse alloc]init];
            cacheResponse.data = result;
            cacheResponse.statusCode = response.statusCode;
            cacheResponse.fields = [[NSMutableDictionary alloc]initWithDictionary:response.allHeaderFields];
            [[MCUrlCache  getInstance]storeResponse:cacheResponse forUrl:urlAsString];
            completeBlock(urlRequest,cacheResponse,result);
        }
    }else {
        NSHTTPURLResponse *response;
        NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
        MCResponse* cacheResponse = [[MCResponse alloc]init];
        cacheResponse.data = result;
        cacheResponse.statusCode = response.statusCode;
        cacheResponse.fields = [[NSMutableDictionary alloc]initWithDictionary:response.allHeaderFields];
        completeBlock(urlRequest,cacheResponse,result);
    }

}


-(void) httpPutSynUrl:(NSString*)httpUrl Params:(NSDictionary*)params Cache:(BOOL)cache Complete:(completeBlock)completeBlock 
{
    NSString *urlAsString = httpUrl;
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:15.0f];
    [urlRequest setHTTPMethod:@"PUT"];
    
    //参数处理
    int count = 1;
    if(params != nil) {
        NSMutableString *body = [NSMutableString stringWithString:@""];
        for (NSString* key in [params allKeys]){
            NSString* value = [params objectForKey:key];
            if(count == 1)
                [body appendFormat:@"%@=%@",key,value];
            else
                [body appendFormat:@"&%@=%@",key,value];
            count++;
        }
        [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (cache) {
        //处理cache逻辑如果有cache就从cache中读取
        MCResponse* cacheResponse = [[MCUrlCache getInstance]cachedResponseForUrl:urlAsString];
        if (cacheResponse) {
            NSData* data = [cacheResponse data];
            completeBlock(urlRequest,cacheResponse,data);
        }else {
            NSHTTPURLResponse *response;
            NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
            cacheResponse = [[MCResponse alloc]init];
            cacheResponse.data = result;
            cacheResponse.statusCode = response.statusCode;
            cacheResponse.fields = [[NSMutableDictionary alloc]initWithDictionary:response.allHeaderFields];
            [[MCUrlCache  getInstance]storeResponse:cacheResponse forUrl:urlAsString];
            completeBlock(urlRequest,cacheResponse,result);
        }
    }else {
        NSHTTPURLResponse *response;
        NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
        MCResponse* cacheResponse = [[MCResponse alloc]init];
        cacheResponse.data = result;
        cacheResponse.statusCode = response.statusCode;
        cacheResponse.fields = [[NSMutableDictionary alloc]initWithDictionary:response.allHeaderFields];
        completeBlock(urlRequest,cacheResponse,result);
    }
}

-(UIImage*) loadImageFromSource:(NSString*)url
{
    __block NSData* imgData= nil;
    [instance httpGetSynUrl:url Params:nil Cache:YES Complete:^(NSURLRequest *request, MCResponse *response, NSData *data) {
        imgData = data;
    }];
    if (imgData) {
        return [UIImage imageWithData:imgData];
    }else {
        return nil;
    }
    
}

@end
