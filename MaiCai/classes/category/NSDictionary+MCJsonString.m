//
//  NSDictionary+MCJsonString.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-23.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "NSDictionary+MCJsonString.h"

@implementation NSDictionary (MCJsonString)
-(NSString*)jsonStringWithPrettyPrint:(BOOL) prettyPrint
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
         return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else {
        return @"{}";
    }
}
@end
