//
//  MCOrder.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCOrder : NSObject
@property unsigned int id;
@property NSString* shipper;
@property NSString* tel;
@property NSString* address;
@property NSString* orderNo;
@property NSString* shopId;
@property NSString* marketName;
@property NSString* shopName;
@property NSString* customerId;
@property float total;
@property NSString* status;
@property NSString* dateAdded;
@property NSString* dateModified;
@property NSString* image;
@property unsigned int quantity;
@property NSString* paymentMethod;
@property NSString* shipMethod;
@property NSMutableArray* products;
@property NSString* message;
@end
