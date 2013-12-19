//
//  MCDBManger.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

@interface MCDBManger : NSObject
+(MCDBManger*)getInstance;
-(FMDatabase*)getDB;
-(void)createTable;
-(NSString*)getSqliteFilePath;

@end
