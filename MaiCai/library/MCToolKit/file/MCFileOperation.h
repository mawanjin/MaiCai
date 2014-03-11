//
//  MCFileOperation.h
//  MaiCai
//
//  Created by Peng Jack on 14-1-24.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCFileOperation : NSObject
+(MCFileOperation*)getInstance;
-(BOOL) createFolder:(NSString *)paramPath;
-(BOOL) writeTextToFile:(NSString *)path Contents:(NSString *)contents;
-(NSString *) readTextFromPath:(NSString *)paramPath;
-(BOOL) emptyFolder:(NSString *)paramPath;
-(BOOL) deleteFolderOrFile:(NSString *)paramPath;
-(long)fileSizeForDir:(NSString*)path;
-(void)clearExpiredFileCache;

-(BOOL)saveObject:(NSObject<NSCoding>*)obj toFilePath:(NSString*)path;
-(NSObject*)getObjectFromFilePath:(NSString*)path;

-(NSString*)getDocumentPath;
-(NSString*)getCachePath;
-(NSString*)getTmpPath;
@end
