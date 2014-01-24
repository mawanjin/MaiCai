//
//  MCFileOperation.h
//  MaiCai
//
//  Created by Peng Jack on 14-1-24.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCFileOperation : NSObject
@property NSFileManager* fileManager;

+(MCFileOperation*)getInstance;
- (void) createFolder:(NSString *)paramPath;
- (void) writeTextToFile:(NSString *)path Contents:(NSString *)contents;
- (NSString *) readTextFromPath:(NSString *)paramPath;
- (void) emptyFolder:(NSString *)paramPath;
- (void) deleteFolderOrFile:(NSString *)paramPath;
-(long)fileSizeForDir:(NSString*)path;
-(NSString*)getDocumentPath;
-(NSString*)getCachePath;
-(NSString*)getTmpPath;
@end
