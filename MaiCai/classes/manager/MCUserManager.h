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
-(MCUser*)getDefaultUser;
-(void)registerUser:(MCUser*)user MacId:(NSString*)macId;
-(void)insertUserToLocalDB:(MCUser*)user;
-(void)login:(MCUser*)user;
-(MCUser*)getUserInfo:(NSString*)id;
-(void)changeNickName:(NSString*)nickname;
-(void)changePassword:(NSString*)oldPassword NewPassword:(NSString*)newPassword;
-(NSMutableArray*)getUserAddressByUserId:(NSString*)id;
-(void)addUserAddress:(MCAddress*)address UserId:(NSString*)id;
-(void)deleteUserAddressById:(NSString*)addressId UserId:(NSString*)userId;
-(void)updateUserAddress:(MCAddress*)address UserId:(NSString*)userId;
-(void)feedbackByTel:(NSString*)tel Content:(NSString*)content;
@end
