//
//  MCContextManager.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-14.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCContextManager.h"
#import "MCNetwork.h"


@implementation MCContextManager
static MCContextManager* instance;
NSMutableDictionary* dictionary;
bool isLogged;


+(MCContextManager*)getInstance
{
    @synchronized (self){
        if (instance == nil) {
            instance = [[MCContextManager alloc] init];
            dictionary = [[NSMutableDictionary alloc]init];
        }
    }
    return instance;
}

-(void)addKey:(NSString*)key Data:(NSObject*)data
{
    [dictionary setObject:data forKey:key];
}

-(NSObject*)getDataByKey:(NSString*)key;
{
    return dictionary[key];
}

-(BOOL)isLogged
{
    return isLogged;
}

-(void)setLogged:(BOOL)value
{
    isLogged = value;
}

-(BOOL)submitErrorMessage:(NSString*) errorMessage
{
    NSDictionary* params = @{
                             @"content":errorMessage,
                             @"log_type":@"4"
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSString* url = [[NSString alloc]initWithFormat:@"%@maicai/mobile/client/log.do",MC_BASE_URL];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:url Params:data];
    if (result == nil) {
        return false;
    }
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    return flag;
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//密码
- (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,10}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

@end
