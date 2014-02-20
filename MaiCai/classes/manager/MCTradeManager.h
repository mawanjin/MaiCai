//
//  MCTradeManager.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-15.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@class MCVegetable;
@class MCAddress;
@class MCOrder;

typedef enum
{
    TO_PAY = 0,
    TO_SHIP=1,
    SHIPPED=2,
    COMPLETED=3,
    CANCELLED=4
}orderStatus;

@interface MCTradeManager : NSObject
+(MCTradeManager*)getInstance;
-(NSMutableArray*)getCartProductsByUserId:(NSString*)id;
-(int)getProductsNumInCartByUserId:(NSString*)id;
-(NSMutableArray*)getCartProductsOnlineByUserId:(NSString*)id;

-(int)getProductsNumInCartOnlineByUserId:(NSString*)id;
-(NSString*)submitOrder:(NSMutableArray*)orders PaymentMethod:(unsigned int)method ShipMethod:(unsigned int)shipMethod Address:(MCAddress*)address UserId:(NSString*)userId TotalPrice:(float)totalPrice Review:(NSString*)review;
-(NSMutableArray*)getOrdersByUserId:(NSString*)userId Status:(NSString*)status;
-(MCOrder*)getOrderDetailByOrderId:(NSString*)orderId;
-(NSString*)getPaymentNoByUserId:(NSString*)userId OrderIds:(NSString*)ids Amount:(float)amount;

-(BOOL)deleteProductsInCartByUserId:(NSString*)id ProductIds:(NSMutableArray*)productIds;
-(BOOL)changeProductNumInCartByUserId:(NSString*)id ProductId:(int)productId Quantity:(int)quantity;
-(BOOL)addProductToCartOnlineByUserId:(NSString *)id Products:(NSArray*)products Recipe:(NSDictionary*)recipe;
-(BOOL)addProductToCartByUserId:(NSString *)id Products:(NSArray*)products Recipe:(NSDictionary*)recipe;
-(BOOL)deleteProductsInCartOnlineByUserId:(NSString*)id ProductIds:(NSMutableArray*)productIds;
-(BOOL)changeProductNumInCartOnlineByUserId:(NSString*)id ProductId:(int)productId Quantity:(int)quantity;
-(BOOL)cancelPaymentByPaymentNo:(NSString*)paymentNo;
@end
