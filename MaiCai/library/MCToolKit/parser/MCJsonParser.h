//
//  MCJsonParser.h
//  MCToolKit
//
//  Created by Peng Jack on 14-3-5.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCJsonParser : NSObject
+(MCJsonParser*)getInstance;
-(NSString*) getJsonStringFromDictionary:(NSDictionary*)dictionary PrettyPrint:(BOOL)prettyPrint;
-(NSDictionary*)parseJsonStringToDictionary:(NSString*)string;
-(NSString*) getJsonStringFromArray:(NSArray*)array PrettyPrint:(BOOL)prettyPrint;
-(NSArray*) parseJsonStringToArray:(NSString*)string;
@end
