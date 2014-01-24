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
            instance.fileManager = [[NSFileManager alloc] init];
        }
    }
    return instance;
}



/* 创建文件夹 */
- (void) createFolder:(NSString *)paramPath{
    NSError *error = nil;
    if ([self.fileManager createDirectoryAtPath:paramPath
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error] == NO){
        NSLog(@"Failed to create folder %@. Error = %@",
              paramPath,
              error);
    }
}
/*把内存中的文本信息写入文件*/
- (void) writeTextToFile:(NSString *)path Contents:(NSString *)contents{
        NSError *error = nil;
        if ([contents writeToFile:path
                           atomically:YES
                             encoding:NSUTF8StringEncoding
                                error:&error] == NO){
            NSLog(@"Failed to save file to %@. Error = %@", path, error);
        }
    
}

/*把文件内容读入内存*/
- (NSString *) readTextFromPath:(NSString *)paramPath{
    return [[NSString alloc] initWithContentsOfFile:paramPath
                                           encoding:NSUTF8StringEncoding
                                              error:nil];
}

/* 清空文件夹*/
- (void) emptyFolder:(NSString *)paramPath{
    NSError *error = nil;
    NSArray *contents = [self.fileManager contentsOfDirectoryAtPath:paramPath
                                                              error:&error];
    if (error == nil){
        error = nil;
        for (NSString *fileName in contents){
            NSString *filePath = [paramPath
                                  stringByAppendingPathComponent:fileName];
            if ([self.fileManager removeItemAtPath:filePath
                                             error:&error] == NO){
                NSLog(@"Failed to remove item at path %@. Error = %@",
                      fileName,
                      error);
            }
        }
    } else {
        NSLog(@"Failed to enumerate path %@. Error = %@", paramPath, error);
    }
}


/* 删除某个文件或者文件夹 */
- (void) deleteFolderOrFile:(NSString *)paramPath{
    NSError *error = nil;
    if ([self.fileManager removeItemAtPath:paramPath error:&error] == NO){
        NSLog(@"Failed to remove path %@. Error = %@", paramPath, error);
    }
}


/*计算某个文件夹大小*/
-(long)fileSizeForDir:(NSString*)path
{
    long size = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray* array = [self.fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic = [self.fileManager attributesOfItemAtPath:fullPath error:nil];
            size += fileAttributeDic.fileSize;
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }
    return size;
    
}

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
