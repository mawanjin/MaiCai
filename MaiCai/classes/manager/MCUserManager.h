//
//  MCUserManager.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@class MCUser;
@class MCAddress;

@interface MCUserManager : NSObject
+(MCUserManager*)getInstance;
-(BOOL)registerUser:(MCUser*)user MacId:(NSString*)macId;
-(BOOL)login:(MCUser*)user;
-(MCUser*)getUserInfo:(NSString*)id;
-(BOOL)changeNickName:(NSString*)nickname;
-(BOOL)changePassword:(NSString*)oldPassword NewPassword:(NSString*)newPassword;
-(NSMutableArray*)getUserAddressByUserId:(NSString*)id;
-(BOOL)addUserAddress:(MCAddress*)address UserId:(NSString*)id;
-(BOOL)deleteUserAddressById:(NSString*)addressId UserId:(NSString*)userId;
-(BOOL)updateUserAddress:(MCAddress*)address UserId:(NSString*)userId;
-(BOOL)feedbackByTel:(NSString*)tel Content:(NSString*)content;
-(void)saveLoginStatusByUser:(MCUser*)user;
-(NSMutableArray*)getAddressHelperList;
-(MCUser*)getLoginStatus;
-(void)clearLoginStatus;
@end
