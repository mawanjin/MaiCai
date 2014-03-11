//
//  MCUrlCache.m
//  MCToolKit
//
//  Created by Peng Jack on 14-3-10.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCUrlCache.h"
#import "MCFileOperation.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MCUrlCache
static MCUrlCache* instance;

+(MCUrlCache*)getInstance
{
    @synchronized (self){
        if (instance == nil) {
            instance = [[MCUrlCache alloc] init];
            instance.baseDiskPath = [[MCFileOperation getInstance]getCachePath];
            //instance.cachePath = [[NSString alloc]initWithFormat:@"%@/%@",instance.baseDiskPath,@"MCCache"];
        }
    }
    return instance;
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (MCResponse *)cachedResponseForUrl:(NSString *)url
{
    NSString* path = [[NSString alloc]initWithFormat:@"%@/%@",self.baseDiskPath,[self md5:url]];
    MCResponse* response = (MCResponse*)[[MCFileOperation getInstance]getObjectFromFilePath:path];
    long long expires = [response.fields[@"Expires"]longLongValue];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    long long current = [[NSString stringWithFormat:@"%.0f", a]longLongValue];
    if (current>expires && expires) {
        [[MCFileOperation getInstance]deleteFolderOrFile:path];
        return nil;
    }else if (expires == 0) {
        return nil;
    }else {
        return response;
    }
}

- (void)storeResponse:(MCResponse *)response forUrl:(NSString*)url
{
    long long expires = [response.fields[@"Expires"]longLongValue];
    NSString* path = [[NSString alloc]initWithFormat:@"%@/%@",self.baseDiskPath,[self md5:url]];
    if (expires) {
        [[MCFileOperation getInstance]saveObject:response toFilePath:path];
    } else {
        NSTimeInterval a=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1000;
        long long current = [[NSString stringWithFormat:@"%.0f", a]longLongValue];
        expires = current+60*60*24;
        response.fields[@"Expires"] = [[NSString alloc]initWithFormat:@"%llu",expires];
        [[MCFileOperation getInstance]saveObject:response toFilePath:path];
    }
}

- (void)removeCachedResponseForUrl:(NSString *)url
{
    NSString* path = [[NSString alloc]initWithFormat:@"%@/%@",self.baseDiskPath,[self md5:url]];
    [[MCFileOperation getInstance]deleteFolderOrFile:path];
}

- (void)removeAllCachedResponses
{
    [[MCFileOperation getInstance]emptyFolder:self.baseDiskPath];
}

- (double)currentDiskUsage
{
    long cacheSize = [[MCFileOperation getInstance] fileSizeForDir:self.baseDiskPath];
    const unsigned int bytes = 1024*1024 ;   //字节数，如果想获取KB就1024，MB就1024*1024
    double value = 1.0*cacheSize/bytes;
    return value;
}
@end
