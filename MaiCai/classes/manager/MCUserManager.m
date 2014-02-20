//
//  MCUserManager.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCUserManager.h"
#import "MCUser.h"
#import "MCNetwork.h"
#import "MCContextManager.h"
#import "MCAddress.h"
#import "NSString+MD5Addition.h"
#import "MCFileOperation.h"


@implementation MCUserManager
static MCUserManager* instance;

+(MCUserManager*)getInstance
{
    @synchronized (self){
        if (instance == nil) {
            instance = [[MCUserManager alloc] init];
        }
    }
    return instance;
}

-(BOOL)registerUser:(MCUser*)user MacId:(NSString*)macId
{
    NSString* param = [[NSString alloc]initWithFormat:@"{\"id\":\"%@\",\"name\":\"%@\",\"password\":\"%@\",\"mac\":\"%@\"}",user.userId,user.name,user.password,macId];
    NSString* sign = [@"/api/ios/v1/private/customer/register.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"param":param,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/customer/register.do" Params:data];
    if (result == nil) {
        return false;
    }
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
     MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(flag) {
        return true;
    }else {
        return false;
    }
}

-(BOOL)login:(MCUser*)user {
    NSString* param = [[NSString alloc]initWithFormat:@"{\"id\":\"%@\",\"password\":\"%@\"}",user.userId,user.password];
    NSString* sign = [@"/api/ios/v1/private/customer/login.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"param":param,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/customer/login.do" Params:data];
    if (result == nil) {
        return false;
    }
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
     MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(flag) {
        NSDictionary* address_ = ((NSDictionary*)responseData[@"data"])[@"address"];
        if(address_ !=nil && address_ != (NSDictionary*)[NSNull null] && [address_ count]>0) {
            MCAddress* address = [[MCAddress alloc]init];
            address.id = [address_[@"id"]integerValue];
            address.name = address_[@"name"];
            address.shipper = address_[@"shipper"];
            address.mobile = address_[@"tel"];
            address.address = address_[@"address"];
            user.defaultAddress = address;
        }
        
        [[MCContextManager getInstance] addKey:MC_USER Data:user];
        [[MCContextManager getInstance] setLogged:YES];
        
        [[MCUserManager getInstance]saveLoginStatusByUser:user];
        return true;
    }else {
        return false;
    }
}

-(MCUser*)getUserInfo:(NSString*)id
{
    
    NSString* sign = [@"/api/ios/v1/private/customer/index.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                 @"id":id,
                                                                                 @"sign":sign
                                                                                 }];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/private/customer/index.do" Params:params];
    if (result == nil) {
        return nil;
    }
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
     MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(flag) {
        MCUser* user = [[MCUser alloc]init];
        user.userId = ((NSDictionary*)responseData[@"data"])[@"id"];
        user.name = ((NSDictionary*)responseData[@"data"])[@"name"];
        return user;
    }else {
        return nil;
    }
}

-(BOOL)changeNickName:(NSString*)nickname
{
    MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
    
    NSString* param = [[NSString alloc]initWithFormat:@"{\"id\":\"%@\",\"name\":\"%@\"}",user.userId,nickname];
    NSString* sign = [@"/api/ios/v1/private/customer/update/name.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"param":param,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/customer/update/name.do" Params:data];
    if (result == nil) {
        return false;
    }
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
     MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(flag) {
        return true;
    }else {
        return false;
    }
}

-(BOOL)changePassword:(NSString*)oldPassword NewPassword:(NSString*)newPassword
{
    MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
    
    NSString* param = [[NSString alloc]initWithFormat:@"{\"id\":\"%@\",\"password\":\"%@\",\"new_password\":\"%@\"}",user.userId,oldPassword,newPassword];
    NSString* sign = [@"/api/ios/v1/private/customer/update/password.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"param":param,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/customer/update/password.do" Params:data];
    if (result == nil) {
        return false;
    }
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
     BOOL flag = [responseData[@"success"]boolValue];
     MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(flag) {
        return true;
    }else {
        return false;
    }
}

-(NSMutableArray*)getUserAddressByUserId:(NSString*)id {
    NSString* sign = [@"/api/ios/v1/private/address/index.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"id":id,
                                                                                   @"sign":sign
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/private/address/index.do" Params:params];
    if (result == nil) {
        return nil;
    }
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
     MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(flag) {
        NSArray* dataArray = responseData[@"data"];
        NSMutableArray* finalResult = [[NSMutableArray alloc]init];
        unsigned int i=0;
        for(i=0;i<dataArray.count;i++) {
            NSDictionary* temp = dataArray[i];
            MCAddress* address = [[MCAddress alloc]init];
            address.id = [temp[@"id"]integerValue];
            address.name = temp[@"name"];
            address.shipper = temp[@"shipper"];
            address.mobile = temp[@"tel"];
            address.address = temp[@"address"];
            [finalResult addObject:address];
        }
        return finalResult;
    }else {
        return nil;
    }
}


-(BOOL)addUserAddress:(MCAddress*)address UserId:(NSString*)id {
    NSString* sign = [@"/api/ios/v1/private/address/save.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSString* param = [[NSString alloc]initWithFormat:@"{\"customer_id\":\"%@\",\"name\":\"%@\",\"shipper\":\"%@\",\"tel\":\"%@\",\"address\":\"%@\"}",id,address.name,address.shipper,address.mobile,address.address];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"param":param,
                                                                                   @"sign":sign
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/private/address/save.do" Params:params];
    
    if (result == nil) {
        return false;
    }
    
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
     MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(flag) {
        return true;
    }else {
        return false;
    }
   
}


-(BOOL)deleteUserAddressById:(NSString*)addressId UserId:(NSString*)userId;
{
    NSString* sign = [@"/api/ios/v1/private/address/delete.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSString* param = [[NSString alloc]initWithFormat:@"{\"ids\":[%@],\"customer_id\":\"%@\"}",addressId,userId];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"param":param,
                                                                                   @"sign":sign
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/private/address/delete.do" Params:params];
    
    if (result == nil) {
        return false;
    }
    
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    return flag;
}

-(BOOL)updateUserAddress:(MCAddress*)address UserId:(NSString*)userId;
{
    NSString* sign = [@"/api/ios/v1/private/address/update.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSString* param = [[NSString alloc]initWithFormat:@"{\"id\":\"%d\",\"customer_id\":\"%@\",\"shipper\":\"%@\",\"tel\":\"%@\",\"address\":\"%@\"}",address.id,userId,address.shipper,address.mobile,address.address];
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"param":param,
                                                                                   @"sign":sign
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/private/address/update.do" Params:params];
    if (result == nil) {
        return false;
    }
    
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
     MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    return flag;
}

-(BOOL)feedbackByTel:(NSString*)tel Content:(NSString*)content
{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"suggest":content,
                                                                                    @"tel":tel
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl: @"http://star-faith.com:8083/maicai/mobile/client/feedback.do" Params:params];
    if (result == nil) {
        return false;
    }
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
     MCLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    return flag;
}

-(void)saveLoginStatusByUser:(MCUser*)user
{
    NSString * path = [[[MCFileOperation getInstance]getDocumentPath] stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@.txt",[@"UserLoginStatus" stringFromMD5]]];

    [NSKeyedArchiver archiveRootObject:user toFile:path];
}

-(MCUser*)getLoginStatus{
    NSString * path = [[[MCFileOperation getInstance]getDocumentPath] stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@.txt",[@"UserLoginStatus" stringFromMD5]]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

-(void)clearLoginStatus{
    NSString * path = [[[MCFileOperation getInstance]getDocumentPath] stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@.txt",[@"UserLoginStatus" stringFromMD5]]];
    [[MCFileOperation getInstance]deleteFolderOrFile:path];
}

@end
