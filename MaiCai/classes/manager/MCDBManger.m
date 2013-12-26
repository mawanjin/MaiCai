//
//  MCDBManger.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCDBManger.h"
#import "FMDatabase.h"

@implementation MCDBManger
static MCDBManger* instance;

+(MCDBManger*)getInstance
{
    @synchronized (self){
        if (instance == nil) {
            instance = [[MCDBManger alloc] init];
        }
    }
    return instance;
}

-(FMDatabase*)getDB
{
    FMDatabase* db = [FMDatabase databaseWithPath:[instance getSqliteFilePath]];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return Nil ;
    }
    return db;
}

-(void)createTable
{
    FMDatabase* db = [self getDB];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    NSString* mc_user = @"create table if not exists mc_user (id integer primary key autoincrement,user_id varchar(50),password varchar(100),name varchar(100),image varchar(100))";
//    NSString* mc_url_cache = @"create table if not exists mc_url_cache(id integer primary key autoincrement,url varchar(200),expire varchar(20),content text)";
    
    [db executeUpdate:mc_user];
//    [db executeUpdate:mc_url_cache];
    [db close];
}


-(NSString*)getSqliteFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"maicai.sqlite"];
    NSLog(@"%@",dbPath);
    return dbPath;
}

@end
