//
//  MCJsonParser.m
//  MCToolKit
//
//  Created by Peng Jack on 14-3-5.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCJsonParser.h"

@implementation MCJsonParser

static MCJsonParser* instance;

+(MCJsonParser*)getInstance
{
    @synchronized (self){
        if (instance == nil) {
            instance = [[MCJsonParser alloc] init];
        }
    }
    return instance;
}

-(NSString*) getJsonStringFromDictionary:(NSDictionary*)dictionary PrettyPrint:(BOOL)prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else {
        return @"{}";
    }
}

-(NSDictionary*)parseJsonStringToDictionary:(NSString*)string
{
    NSError *error;
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                     options:NSJSONReadingAllowFragments
                     error:&error];
    if (jsonObject != nil && error == nil){
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            return jsonObject;
        }else {
            return nil;
        }
    }else {
        return nil;
    }
    
}

-(NSString*) getJsonStringFromArray:(NSArray*)array PrettyPrint:(BOOL)prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else {
        return @"{}";
    }

}

-(NSArray*) parseJsonStringToArray:(NSString*)string
{
    NSError *error;
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                     options:NSJSONReadingAllowFragments
                     error:&error];
    if (jsonObject != nil && error == nil){
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            return jsonObject;
        }else {
            return nil;
        }
    }else {
        return nil;
    }

}

@end
