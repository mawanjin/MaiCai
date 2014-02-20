//
//  MCNetwork.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-2.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCNetwork.h"
#import "NSString+MD5Addition.h"
#import "MCNetWorkObject.h"
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


-(NSData*) httpGetSynUrl:(NSString*)httpUrl Params:(NSMutableDictionary*)params Cache:(BOOL)flag
{
    NSString *urlAsString = httpUrl;
    int count = 1;
    if(params != nil) {
        for (NSString* key in [params allKeys]){
            NSString* value = [params objectForKey:key];
            if(count == 1)
                urlAsString = [urlAsString stringByAppendingFormat:@"?%@=%@",key,value];
            else
                urlAsString = [urlAsString stringByAppendingFormat:@"&%@=%@",key,value];
            count++;
        }
    }
    
    NSString * path = [[[MCFileOperation getInstance]getDocumentPath] stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@.txt",[urlAsString stringFromMD5]]];
    
    MCNetWorkObject* data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    //如何有缓存，并且没有过有效期
    if(data != nil || flag == true) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *currentTime = [NSString stringWithFormat:@"%.0f", a];
        if([currentTime longLongValue]<[data.expire longLongValue]) {
            MCLog(@"从缓存中读取...");
            return data.data;
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
         MCLog(@"此次请求状态码是%ld",(long)[response statusCode]);
        if((long)[response statusCode] == 200) {
            // 取得所有的请求的头
            NSDictionary *dictionary = [response allHeaderFields];
            NSString* expires = dictionary[@"Expires"];
            if(flag == true) {
                //存入缓存
                MCNetWorkObject* object = [[MCNetWorkObject alloc]init];
                object.expire = expires;
                object.data = result;
                [NSKeyedArchiver archiveRootObject:object toFile:path];
            }
            return result;
        }
    }
    return nil;
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
    
    if(params != nil) {
        for (NSString* key in [params allKeys]){
            NSString* value = [params objectForKey:key];
            if(count == 1)
                body = [body stringByAppendingFormat:@"%@=%@",key,value];
            else
                body = [body stringByAppendingFormat:@"&%@=%@",key,value];
            count++;
        }
    }
    
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
   
    NSHTTPURLResponse *response;
    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        // 取得http状态码
        MCLog(@"此次请求状态码是%ld",(long)[response statusCode]);
        if((long)[response statusCode] == 200) {
            return result;
        }
    }
    return nil;
}

-(UIImage*) loadImageFromSource:(NSString*)url
{
    NSString * path = [[[MCFileOperation getInstance]getCachePath] stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@",[url stringFromMD5]]];
    
    MCNetWorkObject* data  = [NSKeyedUnarchiver unarchiveObjectWithFile: path];
    
    if(data != Nil) {
        //如果有缓存读缓存
        NSData* imgData = data.data;
        MCLog(@"读取缓存文件");
        return [UIImage imageWithData:imgData];
    }
        
    //缓存过期 或者 没有缓存文件
    NSError *error=nil;
    NSURL *u=[NSURL URLWithString:url];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:u];
    
    NSHTTPURLResponse *response;
    NSData* imgData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        // 取得http状态码
        MCLog(@"此次请求状态码是%ld",(long)[response statusCode]);
        if((long)[response statusCode] == 200) {
            // 取得所有的请求的头
            NSDictionary *dictionary = [response allHeaderFields];
            NSString* expires = dictionary[@"Expires"];
            
            MCNetWorkObject* object = [[MCNetWorkObject alloc]init];
            object.expire = expires;
            object.data = imgData;
            //建立缓存
            [NSKeyedArchiver archiveRootObject:object toFile:path];
            
            return [UIImage imageWithData:imgData];
        }
    }
    return nil;
}

/*计算缓存整体缓存大小*/
- (NSString *)sizeImageCache{
    MCFileOperation* operation = [MCFileOperation getInstance];
    long docSize = 0;
    long ImageCacheSize = [operation fileSizeForDir:[operation getCachePath]];
    
    long totalSize = docSize + ImageCacheSize;
    const unsigned int bytes = 1024*1024 ;   //字节数，如果想获取KB就1024，MB就1024*1024
    NSString *string = [NSString stringWithFormat:@"%.2f",(1.0 *totalSize/bytes)];
    //MCLog(@"docSize:%ld,ImageCacheSize:%ld",docSize,ImageCacheSize);
    return string;
}

- (NSString *)sizeDocumentCache{
    MCFileOperation* operation = [MCFileOperation getInstance];
    long docSize = [operation fileSizeForDir:[operation getDocumentPath]];
    long ImageCacheSize = 0;
    
    long totalSize = docSize + ImageCacheSize;
    const unsigned int bytes = 1024*1024 ;   //字节数，如果想获取KB就1024，MB就1024*1024
    NSString *string = [NSString stringWithFormat:@"%.2f",(1.0 *totalSize/bytes)];
    //MCLog(@"docSize:%ld,ImageCacheSize:%ld",docSize,ImageCacheSize);
    return string;
}

-(void)clearImageCache
{
    MCFileOperation* operation = [MCFileOperation getInstance];
    //[operation emptyFolder:[operation getDocumentPath]];
    [operation emptyFolder:[operation getCachePath]];
}

-(void)clearDocumentCache
{
    MCFileOperation* operation = [MCFileOperation getInstance];
    [operation emptyFolder:[operation getDocumentPath]];
    //[operation emptyFolder:[operation getCachePath]];
}
@end
