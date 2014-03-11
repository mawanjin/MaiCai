//
//  MCFileOperation.m
//  MaiCai
//
//  Created by Peng Jack on 14-1-24.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCFileOperation.h"

@implementation MCFileOperation

static MCFileOperation* instance;

+(MCFileOperation*)getInstance
{
    @synchronized (self){
        if (instance == nil) {
            instance = [[MCFileOperation alloc] init];
        }
    }
    return instance;
}

#pragma mark-文件处理操作
/* 创建文件夹 */
- (BOOL) createFolder:(NSString *)paramPath{
    NSError *error = nil;
    return [[NSFileManager defaultManager] createDirectoryAtPath:paramPath withIntermediateDirectories:YES attributes:nil error:&error];
}

/*把内存中的文本信息写入文件*/
- (BOOL) writeTextToFile:(NSString *)path Contents:(NSString *)contents{
        NSError *error = nil;
        return [contents writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

/*把文件内容读入内存*/
- (NSString *) readTextFromPath:(NSString *)paramPath{
    return [[NSString alloc] initWithContentsOfFile:paramPath encoding:NSUTF8StringEncoding error:nil];
}

/* 清空文件夹*/
- (BOOL) emptyFolder:(NSString *)paramPath{
    NSError *error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:paramPath error:&error];
    int count = (int)contents.count;
    --count;
    if (error == nil){
        error = nil;
        for (NSString *fileName in contents){
            NSString *filePath = [paramPath stringByAppendingPathComponent:fileName];
            if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error] == NO){
               
            }else {
                --count;
            }
        }
    } else {
        return false;
    }
    if (count == 0) {
        return true;
    }else {
        return false;
    }
}


/* 删除某个文件或者文件夹 */
- (BOOL) deleteFolderOrFile:(NSString *)paramPath{
    NSError *error = nil;
    return [[NSFileManager defaultManager] removeItemAtPath:paramPath error:&error];
}


/*计算某个文件夹大小*/
-(long)fileSizeForDir:(NSString*)path
{
    long size = 0;
    NSArray* array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            size += fileAttributeDic.fileSize;
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }
    return size;
}

/*清除缓存中的过期文件*/
-(void)clearExpiredFileCache
{
    NSString *filePath = [[MCFileOperation getInstance]getTmpPath];
    NSDirectoryEnumerator *fileNames = [[NSFileManager defaultManager] enumeratorAtPath:filePath];
    NSTimeInterval maximumTimeInterval = 1 * 24 * 3600; // 1 days caching
    for (NSString *fileName in fileNames) {
        NSString *uniquePath = [filePath stringByAppendingPathComponent:fileName];
        NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:uniquePath
                                                                                    error:nil];
        NSDate *createdDate = [attributes objectForKey:NSFileCreationDate];
        if ([createdDate timeIntervalSinceDate:[NSDate date]] > maximumTimeInterval) {
            [[NSFileManager defaultManager] removeItemAtPath:uniquePath error:nil];
        }
    }
}


#pragma mark-存入读取可序列化对象
-(BOOL)saveObject:(NSObject<NSCoding>*)obj toFilePath:(NSString*)path
{
    return [NSKeyedArchiver archiveRootObject:obj toFile:path];
}

-(NSObject*)getObjectFromFilePath:(NSString*)path
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

#pragma mark-获取app常用系统路径
-(NSString*)getDocumentPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

-(NSString*)getCachePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

-(NSString*)getTmpPath{
    return NSTemporaryDirectory();
}

@end
