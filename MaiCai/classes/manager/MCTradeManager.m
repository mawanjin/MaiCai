//
//  MCTradeManager.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-15.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCTradeManager.h"
#import "MCVegetable.h"
#import "MCNetwork.h"
#import "MCShop.h"
#import "MCMarket.h"
#import "NSString+MD5Addition.h"
#import "MCAddress.h"
#import "MCOrder.h"
#import "MCUser.h"
#import "MCContextManager.h"
#import "NSDictionary+MCJsonString.h"
#import "NSArray+MCJsonString.h"
#import "MCRecipe.h"

@implementation MCTradeManager

static MCTradeManager* instance;

+(MCTradeManager*)getInstance
{
    @synchronized (self){
        if (instance == nil) {
            instance = [[MCTradeManager alloc] init];
        }
    }
    return instance;
}

-(NSMutableArray*)getCartProductsByUserId:(NSString*)id
{
    NSDictionary* params = @{
                             @"id":id,
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/public/offline/cart/index.do" Params:data Cache:NO];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(flag){
        NSDictionary* obj = responseData[@"data"];
         NSMutableArray* finalResult = [[NSMutableArray alloc]init];
        if([obj count] == 0) {
        
        }else {
            NSArray* shops = obj[@"tenants"];
            unsigned int i=0;
            unsigned int j=0;
            unsigned int z=0;
            for(i=0;i<shops.count;i++) {
                NSDictionary* shop = shops[i];
                MCShop* temp = [[MCShop alloc]init];
                temp.id = [shop[@"id"]integerValue];
                temp.name = shop[@"name"];
                MCMarket* market = [[MCMarket alloc]init];
                market.name = shop[@"market_name"];
                temp.market = market;
                NSMutableArray* vegetables = [[NSMutableArray alloc]init];
                NSArray* products = shop[@"products"];
                for(j=0;j<products.count;j++) {
                    NSDictionary* product = products[j];
                    MCVegetable* vegetable = [[MCVegetable alloc]init];
                    vegetable.id = [product[@"id"]integerValue];
                    vegetable.name = product[@"name"];
                    vegetable.product_id = [product[@"product_id"]integerValue];
                    vegetable.price = [product[@"price"]floatValue];
                    vegetable.unit = product[@"unit"];
                    vegetable.quantity = [product[@"quantity"]integerValue];
                    NSArray* recipes_ = product[@"recipes"];
                    NSMutableArray* recipes = [[NSMutableArray alloc]init];
                    if((NSNull*)recipes_ != [NSNull null]) {
                        for(z=0;z<recipes_.count;z++) {
                            NSDictionary* recipe_ = recipes_[z];
                            MCRecipe* recipe = [[MCRecipe alloc]init];
                            recipe.id = [recipe_[@"id"]integerValue];
                            recipe.name = recipe_[@"name"];
                            recipe.image = recipe_[@"image"];
                            recipe.dosage = recipe_[@"dosage"];
                            [recipes addObject:recipe];
                        }
                    }
                    vegetable.recipes = recipes;
                    [vegetables addObject:vegetable];
                }
                temp.vegetables = vegetables;
                [finalResult addObject:temp];
            }
        }
        return finalResult;
    }else {
        NSLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
}

-(NSMutableArray*)getCartProductsOnlineByUserId:(NSString*)id
{
     NSString* sign = [@"/api/ios/v1/private/cart/index.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"id":id,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/cart/index.do" Params:data Cache:NO];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(flag){
        NSDictionary* obj = responseData[@"data"];
        NSMutableArray* finalResult = [[NSMutableArray alloc]init];
        if([obj count] == 0) {
            
        }else {
            NSArray* shops = obj[@"tenants"];
            unsigned int i=0;
            unsigned int j=0;
            for(i=0;i<shops.count;i++) {
                NSDictionary* shop = shops[i];
                MCShop* temp = [[MCShop alloc]init];
                temp.id = [shop[@"id"]integerValue];
                temp.name = shop[@"name"];
                MCMarket* market = [[MCMarket alloc]init];
                market.name = shop[@"market_name"];
                temp.market = market;
                NSMutableArray* vegetables = [[NSMutableArray alloc]init];
                NSArray* products = shop[@"products"];
                for(j=0;j<products.count;j++) {
                    NSDictionary* product = products[j];
                    MCVegetable* vegetable = [[MCVegetable alloc]init];
                    vegetable.id = [product[@"id"]integerValue];
                    vegetable.name = product[@"name"];
                    vegetable.product_id = [product[@"product_id"]integerValue];
                    vegetable.price = [product[@"price"]floatValue];
                    vegetable.unit = product[@"unit"];
                    vegetable.quantity = [product[@"quantity"]integerValue];
                    
                    NSArray* recipes_ = product[@"recipes"];
                    NSMutableArray* recipes = [[NSMutableArray alloc]init];
                    if((NSNull*)recipes_ != [NSNull null]) {
                        for(int z=0;z<recipes_.count;z++) {
                            NSDictionary* recipe_ = recipes_[z];
                            MCRecipe* recipe = [[MCRecipe alloc]init];
                            recipe.id = [recipe_[@"id"]integerValue];
                            recipe.name = recipe_[@"name"];
                            recipe.image = recipe_[@"image"];
                            recipe.dosage = recipe_[@"dosage"];
                            [recipes addObject:recipe];
                        }
                    }
                    vegetable.recipes = recipes;
                    
                    [vegetables addObject:vegetable];
                }
                temp.vegetables = vegetables;
                [finalResult addObject:temp];
            }
        }
        return finalResult;
    }else {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
}


-(void)addProductToCartByUserId:(NSString *)id Products:(NSArray*)products Recipe:(NSDictionary*)recipe
{
    NSDictionary* dic = nil;
    if(recipe == nil) {
        dic = @{
                  @"customer_id":id,
                  @"products":products
               };
    }else {
        dic = @{
                  @"customer_id":id,
                  @"products":products,
                  @"recipe":recipe
               };
    }
   
    NSString* param = [dic jsonStringWithPrettyPrint:NO];
    NSDictionary* params = @{
                             @"param":param
                            };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/public/offline/cart/save.do" Params:data];
    NSError *error;

    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
}



-(void)addProductToCartOnlineByUserId:(NSString *)id Products:(NSArray*)products Recipe:(NSDictionary*)recipe
{
   
   
    NSDictionary* dic = nil;
    if(recipe == nil) {
        dic = @{
                @"customer_id":id,
                @"products":products
                };
    }else {
        dic = @{
                @"customer_id":id,
                @"products":products,
                @"recipe":recipe
                };
    }
    
    NSString* param = [dic jsonStringWithPrettyPrint:NO];
    
    NSString* sign = [@"/api/ios/v1/private/cart/save.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"param":param,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/cart/save.do" Params:data];
    NSError* error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
}


-(int)getProductsNumInCartByUserId:(NSString*)id
{
    NSDictionary* params = @{
                             @"id":id,
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/public/offline/cart/quantity/index.do" Params:data Cache:NO];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    int num = 0;
    
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }else {
        num = [responseData[@"data"]integerValue];
    }
    return num;
}

-(int)getProductsNumInCartOnlineByUserId:(NSString*)id
{
    NSString* sign = [@"/api/ios/v1/private/cart/quantity/index.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"id":id,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/cart/quantity/index.do" Params:data Cache:NO];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    int num = 0;
    
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }else {
        num = [responseData[@"data"]integerValue];
    }
    return num;

}


-(void)changeProductNumInCartByUserId:(NSString*)id ProductId:(int)productId Quantity:(int)quantity
{
    NSString* param = [[NSString alloc]initWithFormat:@"{\"id\":\"%d\",\"customer_id\":\"%@\",\"quantity\":%d}",productId,id,quantity];
  
    NSDictionary* params = @{
                             @"param":param
                             
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/public/offline/cart/quantity/update.do" Params:data];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
}

-(void)changeProductNumInCartOnlineByUserId:(NSString*)id ProductId:(int)productId Quantity:(int)quantity
{
    NSString* param = [[NSString alloc]initWithFormat:@"{\"id\":\"%d\",\"customer_id\":%@,\"quantity\":%d}",productId,id,quantity];
    NSString* sign = [@"/api/ios/v1/private/cart/quantity/update.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"param":param,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/cart/quantity/update.do" Params:data];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
}

-(void)deleteProductsInCartByUserId:(NSString*)id ProductIds:(NSMutableArray*)productIds
{
    
    unsigned int i =0;
    NSMutableString* productIdsStr = [[NSMutableString alloc]initWithString:@""];
    for(i=0;i<productIds.count;i++) {
        [productIdsStr appendString:[[NSString alloc]initWithFormat:@"%@",productIds[i]]];
        if(i!=(productIds.count-1)) {
            [productIdsStr appendString:@","];
        }
    }
    NSString* param = [[NSString alloc]initWithFormat:@"{\"customer_id\":\"%@\",\"product_ids\":[%@]}",id,productIdsStr];
    
    NSDictionary* params = @{
                             @"param":param
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/public/offline/cart/delete.do" Params:data];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
}

-(void)deleteProductsInCartOnlineByUserId:(NSString*)id ProductIds:(NSMutableArray*)productIds
{
    unsigned int i =0;
    NSMutableString* productIdsStr = [[NSMutableString alloc]initWithString:@""];
    for(i=0;i<productIds.count;i++) {
        [productIdsStr appendString:[[NSString alloc]initWithFormat:@"%@",productIds[i]]];
        if(i!=(productIds.count-1)) {
            [productIdsStr appendString:@","];
        }
    }
    NSString* sign = [@"/api/ios/v1/private/cart/delete.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSString* param = [[NSString alloc]initWithFormat:@"{\"customer_id\":\"%@\",\"product_ids\":[%@]}",id,productIdsStr];
    
    NSDictionary* params = @{
                             @"param":param,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/cart/delete.do" Params:data];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
}


-(NSString*)submitOrder:(NSMutableArray*)orders PaymentMethod:(unsigned int)method ShipMethod:(unsigned int)shipMethod Address:(MCAddress*)address UserId:(NSString*)userId TotalPrice:(float)totalPrice
                 Review:(NSString*)review
{
    NSMutableDictionary* param = [[NSMutableDictionary alloc]init];
    NSMutableArray* tenants = [[NSMutableArray alloc]init];
    param[@"customer_id"] = userId;
    param[@"payment_method"] = [[NSNumber alloc]initWithInt:method];
    param[@"ship_method"] =  [[NSNumber alloc]initWithInt:shipMethod];
    unsigned int i=0;
    unsigned int j=0;
    unsigned int z=0;
    for(i=0;i<orders.count;i++) {
        MCShop* shop = orders[i];
        NSMutableDictionary* tenant = [[NSMutableDictionary alloc]init];
        tenant[@"id"] = [[NSNumber alloc]initWithInt:shop.id];
        NSMutableArray* products = [[NSMutableArray alloc]init];
        NSMutableArray* vegetables = shop.vegetables;
        for(j=0;j<vegetables.count;j++) {
            MCVegetable* vegetable = vegetables[j];
            NSMutableDictionary* product = [[NSMutableDictionary alloc]init];
            product[@"id"] = [[NSNumber alloc]initWithInt:vegetable.id];
            product[@"quantity"] = [[NSNumber alloc]initWithInt:vegetable.quantity];
            NSMutableArray* recipes = [[NSMutableArray alloc]init];
            for(z=0;z<vegetable.recipes.count;z++) {
                MCRecipe* temp = vegetable.recipes[z];
                NSMutableDictionary* recipe = [[NSMutableDictionary alloc]init];
                recipe[@"id"] = [[NSNumber alloc]initWithInt:temp.id];
                [recipes addObject:recipe];
            }
            product[@"recipes"] = recipes;
            [products addObject:product];
        }
        tenant[@"products"] = products;
        [tenants addObject:tenant];
    }
    param[@"tenants"] = tenants;
    
    NSMutableDictionary* address_ = [[NSMutableDictionary alloc]init];
    address_[@"id"] = [[NSNumber alloc]initWithInt:address.id];
    if(address.name != Nil) {
        address_[@"name"] = address.name;
    }
    address_[@"shipper"] = address.shipper;
    address_[@"tel"] = address.mobile;
    address_[@"address"] = address.address;
    param[@"address"] = address_;
    param[@"message"] = review;
    param[@"total"] = [[NSNumber alloc]initWithFloat:totalPrice];
    
    NSError *error;
    
    NSString* sign = [@"/api/ios/v1/private/order/save.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"param":[param jsonStringWithPrettyPrint:NO],
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/order/save.do" Params:data];
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    int addressId = [((NSDictionary*)responseData[@"data"])[@"address_id"]integerValue];
    
    MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
    if(user.defaultAddress == Nil) {
        address.id = addressId;
        user.defaultAddress = address;
    }
    return ((NSDictionary*)responseData[@"data"])[@"pay_no"];
}

-(NSMutableArray*)getOrdersByUserId:(NSString*)userId Status:(NSString*)status
{
    NSString* param = [[NSString alloc]initWithFormat:@"{\"customer_id\":\"%@\",\"statuses\":%@}",userId,status];
    NSString* sign = [@"/api/ios/v1/private/order/index.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"param":param,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/order/index.do" Params:data];
    NSString* content = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"%@",content);
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
           }
    NSArray* data_ = responseData[@"data"];
    NSMutableArray* orders = [[NSMutableArray alloc]init];
    unsigned int i=0;
    for(i=0;i<data_.count;i++) {
        NSDictionary* order_ = data_[i];
        MCOrder* order = [[MCOrder alloc]init];
        order.id = [order_[@"id"]integerValue];
        order.shipper = order_[@"shipper"];
        order.tel = order_[@"tel"];
        order.address = order_[@"address"];
        order.orderNo = order_[@"order_no"];
        order.shopId = order_[@"tenant_id"];
        order.marketName = order_[@"market_name"];
        order.shopName = order_[@"tenant_name"];
        order.customerId = order_[@"customer_id"];
        order.total = [order_[@"total"]floatValue];
        order.status = order_[@"status"];
        order.dateAdded = order_[@"date_added"];
        order.dateModified = order_[@"date_modified"];
        order.image = order_[@"image"];
        order.quantity = [order_[@"quantity"]integerValue];
        [orders addObject:order];
    }
    return orders;
}

-(MCOrder*)getOrderDetailByOrderId:(NSString*)orderId
{
    NSString* sign = [@"/api/ios/v1/private/order/detail.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"id":orderId,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/order/detail.do" Params:data];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    NSDictionary* data_ = responseData[@"data"];
    
    MCOrder* order = [[MCOrder alloc]init];
    order.id = [data_[@"id"]integerValue];
    order.shipper = data_[@"shipper"];
    order.tel = data_[@"tel"];
    order.address = data_[@"address"];
    order.orderNo = data_[@"order_no"];
    order.shopId = data_[@"tenant_id"];
    order.marketName = data_[@"market_name"];
    order.shopName = data_[@"tenant_name"];
    order.customerId = data_[@"customer_id"];
    order.total = [data_[@"total"]floatValue];
    order.status = data_[@"status"];
    order.dateAdded = data_[@"date_added"];
    order.dateModified = data_[@"date_modified"];
    order.image = data_[@"image"];
    order.quantity = [data_[@"quantity"]integerValue];
    order.paymentMethod = data_[@"payment_method"];
    order.shipMethod = data_[@"ship_method"];
    order.message = data_[@"message"];
    
    NSArray* products = data_[@"products"];
    NSMutableArray* vegetables = [[NSMutableArray alloc]init];
    unsigned int i=0;
    for (i=0; i<products.count; i++) {
        NSDictionary* product = products[i];
        MCVegetable* vegetable = [[MCVegetable alloc]init];
        vegetable.id = [product[@"id"]integerValue];
        vegetable.name = product[@"name"];
        vegetable.product_id = [product[@"product_id"]integerValue];
        vegetable.quantity = [product[@"quantity"]integerValue];
        vegetable.price = [product[@"price"]floatValue];
        [vegetables addObject:vegetable];
    }
    
    order.products = vegetables;
    
    return order;
}

-(NSString*)getPaymentNoByUserId:(NSString*)userId OrderIds:(NSString*)ids Amount:(float)amount
{
    NSString* sign = [@"/api/ios/v1/private/pay/index.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"customer_id":userId,
                             @"order_ids":ids,
                             @"amount":[[NSString alloc]initWithFormat:@"%.02f",amount],
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/pay/index.do" Params:data];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    NSString* data_ = responseData[@"data"];
    return data_;
}

-(void)cancelPaymentByPaymentNo:(NSString*)paymentNo
{
    NSString* sign = [@"/api/ios/v1/private/pay/esc.dodhfuewjcuehiudjuwdwyfcs" stringFromMD5];
    NSDictionary* params = @{
                             @"id":paymentNo,
                             @"sign":sign
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/private/pay/esc.do" Params:data];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
}
@end
