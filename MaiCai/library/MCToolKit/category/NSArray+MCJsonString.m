//
//  NSArray+MCJsonString.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-23.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "NSArray+MCJsonString.h"

@implementation NSArray (MCJsonString)
-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end
