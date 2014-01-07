//
//  MCVegetableManager.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-4.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCVegetableManager.h"
#import "MCNetwork.h"
#import "MCMarket.h"
#import "MCShop.h"
#import "MCVegetable.h"
#import "MCCategory.h"
#import "MCContextManager.h"
#import "MCRecipe.h"
#import "MCStep.h"
#import "MCHealth.h"

@implementation MCVegetableManager
static MCVegetableManager* instance;
static NSMutableDictionary* relationship;

+(MCVegetableManager*)getInstance
{
    @synchronized (self){
        if (instance == nil) {
            instance = [[MCVegetableManager alloc] init];
        }
    }
    return instance;
}


-(NSMutableArray*)getHotWordsByQuantity:(int)quantity
{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"hot":[[NSString alloc]initWithFormat:@"%d",quantity],
                    
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/public/search/hot.do" Params:params];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    NSLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    
    return responseData[@"data"];
}


-(NSMutableArray*)getSearchResultByKeywords:(NSString*)words Quantity:(int)quantity
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"keyword":words,
                                                                                   @"hot":[[NSString alloc]initWithFormat:@"%d",quantity],
                                                                                   
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/public/search/go.do" Params:params];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    NSLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    return responseData[@"data"];
}


-(NSMutableArray*)getRecipesByPage:(int)page Pagesize:(int)pagesize
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                    @"page":[[NSString alloc]initWithFormat:@"%d",page],
                                                                                    @"pagesize":        [[NSString alloc]initWithFormat:@"%d",pagesize]
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/public/recipe/list.do" Params:params Cache:YES];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    NSLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    
    NSMutableArray* recipes = [[NSMutableArray alloc]init];
    NSArray* data = responseData[@"data"];
    for(int i=0;i<data.count;i++) {
        MCRecipe* recipe = [[MCRecipe alloc]init];
        recipe.id = [data[i][@"id"]integerValue];
        recipe.name = data[i][@"name"];
        recipe.image = data[i][@"image"];
        recipe.bigImage = data[i][@"big_image"];
        recipe.introduction = data[i][@"introduction"];
        recipe.tags = data[i][@"tags"];
        [recipes addObject:recipe];
    }
    return recipes;
}

-(NSMutableArray*)getHealthListByPage:(int)page Pagesize:(int)pagesize
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"page":[[NSString alloc]initWithFormat:@"%d",page],
                                                                                   @"pagesize":        [[NSString alloc]initWithFormat:@"%d",pagesize]
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/public/healthcare/list.do" Params:params Cache:YES];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    NSLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    
    NSMutableArray* healthList = [[NSMutableArray alloc]init];
    NSArray* data = responseData[@"data"];
    for(int i=0;i<data.count;i++) {
        MCHealth* health = [[MCHealth alloc]init];
        health.id = [data[i][@"id"]integerValue];
        health.name = data[i][@"name"];
        health.image = data[i][@"image"];
        health.introduction = data[i][@"introduction"];
        [healthList addObject:health];
    }
    return healthList;
}

-(MCRecipe*)getRecipeById:(int)id
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"id":[[NSString alloc]initWithFormat:@"%d",id]
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/public/recipe/buy.do" Params:params Cache:YES];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    NSLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    NSDictionary* data = responseData[@"data"];
    MCRecipe* recipe = [[MCRecipe alloc]init];
    recipe.id = [data[@"id"]integerValue];
    recipe.name = data[@"name"];
    recipe.bigImage = data[@"big_image"];
    recipe.introduction = data[@"introduction"];
    
    NSArray* mainIngredients_ = data[@"main_ingredients"];
    NSMutableArray* mainIngredients = [[NSMutableArray alloc]init];
    for(int i=0;i<mainIngredients_.count;i++){
        MCVegetable* vegetable = [[MCVegetable alloc]init];
        vegetable.id = [mainIngredients_[i][@"id"]integerValue];
        vegetable.name = mainIngredients_[i][@"name"];
        vegetable.product_id = [mainIngredients_[i][@"product_id"]integerValue];
        vegetable.dosage = mainIngredients_[i][@"dosage"];
        vegetable.price = [mainIngredients_[i][@"price"]floatValue];
        vegetable.unit = mainIngredients_[i][@"unit"];
        [mainIngredients addObject:vegetable];
    }
    recipe.mainIngredients = mainIngredients;
    
    NSArray* accessoryIngredients_ = data[@"accessory_ingredients"];
    NSMutableArray* accessoryIngredients = [[NSMutableArray alloc]init];
    for(int i=0;i<accessoryIngredients_.count;i++){
        MCVegetable* vegetable = [[MCVegetable alloc]init];
        vegetable.id = [accessoryIngredients_[i][@"id"]integerValue];
        vegetable.name = accessoryIngredients_[i][@"name"];
        vegetable.product_id = [accessoryIngredients_[i][@"product_id"]integerValue];
        vegetable.dosage = accessoryIngredients_[i][@"dosage"];
        vegetable.price = [accessoryIngredients_[i][@"price"]floatValue];
        vegetable.unit = accessoryIngredients_[i][@"unit"];
        [accessoryIngredients addObject:vegetable];
    }
    recipe.accessoryIngredients = accessoryIngredients;
    
    return recipe;
}

-(MCRecipe*)getRecipeDetailById:(int)id
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"id":[[NSString alloc]initWithFormat:@"%d",id]
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/public/recipe/index.do" Params:params Cache:YES];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    NSLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    
    NSDictionary* data = responseData[@"data"];
    MCRecipe* recipe = [[MCRecipe alloc]init];
    recipe.id = [data[@"id"]integerValue];
    recipe.name = data[@"name"];
    recipe.image = data[@"image"];
    recipe.bigImage = data[@"big_image"];
    recipe.introduction = data[@"introduction"];
    
    NSArray* steps_ = data[@"items"];
    NSMutableArray* steps = [[NSMutableArray alloc]init];
    for(int i=0;i<steps_.count;i++) {
        MCStep* step = [[MCStep alloc]init];
        step.image = steps_[i][@"image"];
        step.content = steps_[i][@"content"];
        step.sortOrder = [steps_[i][@"sort_order"]integerValue];
        [steps addObject:step];
    }
    recipe.steps = steps;
    
    NSArray* mainIngredients_ = data[@"main_ingredients"];
    NSMutableArray* mainIngredients = [[NSMutableArray alloc]init];
    for(int i=0;i<mainIngredients_.count;i++){
        MCVegetable* vegetable = [[MCVegetable alloc]init];
        vegetable.name = mainIngredients_[i][@"name"];
        //vegetable.product_id = [mainIngredients_[i][@"product_id"]integerValue];
        vegetable.dosage = mainIngredients_[i][@"dosage"];
        [mainIngredients addObject:vegetable];
    }
    recipe.mainIngredients = mainIngredients;
    
    NSArray* accessoryIngredients_ = data[@"accessory_ingredients"];
    NSMutableArray* accessoryIngredients = [[NSMutableArray alloc]init];
    for(int i=0;i<accessoryIngredients_.count;i++){
        MCVegetable* vegetable = [[MCVegetable alloc]init];
        vegetable.name = accessoryIngredients_[i][@"name"];
        //vegetable.product_id = [accessoryIngredients_[i][@"product_id"]integerValue];
        vegetable.dosage = accessoryIngredients_[i][@"dosage"];
        [accessoryIngredients addObject:vegetable];
    }
    recipe.accessoryIngredients = accessoryIngredients;
    
    return recipe;

}


-(NSMutableArray*)getSuggestResultByKeywords:(NSString*)words Quantity:(int)quantity
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                   @"keyword":words,
                                                                                   @"hot":[[NSString alloc]initWithFormat:@"%d",quantity],
                                                                                   
                                                                                   }];
    NSData* result = [[MCNetwork getInstance]httpPostSynUrl: @"http://star-faith.com:8083/maicai/api/ios/v1/public/search/suggest.do" Params:params];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    NSLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    
    return responseData[@"data"];

}

//首页信息
-(NSMutableDictionary*)getMarketIndexInfo
{
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/public/index.do" Params:Nil Cache:YES];
    NSError *error;
    NSDictionary* dicResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [dicResult[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    
    NSDictionary*  data = [dicResult objectForKey:@"data"];
    NSArray* recipes = [data objectForKey:@"recipes"];
    NSArray* labels = [data objectForKey:@"labels"];
    NSArray* products = [data objectForKey:@"products"];
    
    unsigned int i;
    NSMutableArray* recipesArray = [[NSMutableArray alloc]init];
    for(i=0;i<recipes.count;i++) {
        NSDictionary* obj = recipes[i];
        MCRecipe* recipe = [[MCRecipe alloc]init];
        recipe.name = obj[@"name"];
        recipe.id = [obj[@"id"]integerValue];
        recipe.image = obj[@"image"];
        [recipesArray addObject:recipe];
    }
    
    NSMutableArray* productsArray = [[NSMutableArray alloc]init];
    for(i=0;i<products.count;i++) {
        NSDictionary* obj = products[i];
        MCVegetable* temp = [[MCVegetable alloc]init];
        temp.name = obj[@"name"];
        temp.id = [obj[@"id"]integerValue];
        temp.price = [obj[@"price"] floatValue];
        temp.product_id = [obj[@"product_id"]integerValue];
        temp.unit = obj[@"unit"];
        [productsArray addObject:temp];
    }
    
    NSMutableArray* labelsArray = [[NSMutableArray alloc]init];
    for(i=0;i<labels.count;i++) {
        NSDictionary* obj = labels[i];
        NSMutableDictionary* temp = [[NSMutableDictionary alloc]init];
        temp[@"name"] = obj[@"name"];
        temp[@"id"] = obj[@"id"];
        temp[@"color"] = obj[@"color"];
        temp[@"icon"] = obj[@"icon"];
        [labelsArray addObject:temp];
    }
    
    NSDictionary *resultData = @{
                                 @"recipes" :recipesArray ,
                                 @"labels" : labelsArray,
                                 @"products" :productsArray,
                                 @"tip": [data objectForKey:@"tip"]
                             };
    
    NSString* lng = [[NSString alloc]initWithFormat:@"%.06f",[dicResult[@"data"][@"lng"] doubleValue]];
    NSString* lat = [[NSString alloc]initWithFormat:@"%.06f",[dicResult[@"data"][@"lat"] doubleValue]];
    [[MCContextManager getInstance] addKey:MC_CONTEXT_POSITION Data:@{@"lng":lng,@"lat":lat}];
    return [[NSMutableDictionary alloc]initWithDictionary:resultData];
}


-(NSMutableArray*)getMarketProducts
{
    NSString* lng = ((NSDictionary*)[[MCContextManager getInstance]getDataByKey:MC_CONTEXT_POSITION])[@"lng"];
    NSString* lat = ((NSDictionary*)[[MCContextManager getInstance]getDataByKey:MC_CONTEXT_POSITION])[@"lat"];
    NSDictionary* params = @{
                             @"lng":lng,
                             @"lat":lat
                             };
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/public/market/list.do" Params:params Cache:YES];
    NSError *error;
    NSDictionary* dicResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"%@",[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]);
    
    BOOL flag = [dicResult[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    
    NSDictionary*  data = [dicResult objectForKey:@"data"];
    NSArray*  category = [data objectForKey:@"categories"];
    NSMutableArray* categories = [[NSMutableArray alloc]init];
    unsigned int i = 0;
    for(i=0;i<category.count;i++) {
        NSDictionary* obj =category[i];
        MCCategory* temp = [[MCCategory alloc]init];
        temp.id = [obj[@"id"]integerValue];
        temp.name = obj[@"name"];
        NSMutableArray* vegetables = [[NSMutableArray alloc]init];
        NSArray* vegetablesArray = obj[@"products"];
        unsigned int j=0;
        for(j=0;j<vegetablesArray.count;j++) {
            NSDictionary* obj1 = vegetablesArray[j];
            MCVegetable* temp1 = [[MCVegetable alloc]init];
            temp1.id = [obj1[@"id"]integerValue];
            temp1.name = obj1[@"name"];
            temp1.product_id = [obj1[@"product_id"]integerValue];
            temp1.price = [obj1[@"price"]floatValue];
            temp1.unit = obj1[@"unit"];
            [vegetables addObject:temp1];
        }
        temp.vegetables = vegetables;
        [categories addObject:temp];
    }
    return categories;
}


-(NSMutableDictionary*)getVegetableDetailByProductId:(int)id Longitude:(NSString*)longitude Latitude:(NSString*)latitude
{
    NSDictionary* params = @{
                             @"id":[[NSString alloc]initWithFormat:@"%d",id],
                             @"lng":longitude,
                             @"lat":latitude
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/public/product/index.do" Params:data Cache:YES];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    
    NSDictionary* dicResult = responseData[@"data"];
    NSMutableDictionary* obj = [[NSMutableDictionary alloc]init];
    
    obj[@"summary"] =  dicResult[@"summary"];
    NSArray* tenantsArray = dicResult[@"tenants"];
    NSMutableArray* tenants = [[NSMutableArray alloc]init];
    for(int i=0;i<tenantsArray.count;i++) {
        MCShop* tenant = [[MCShop alloc]init];
        NSDictionary* tenant_ = tenantsArray[i];
        tenant.id = [tenant_[@"id"]integerValue];
        tenant.name = tenant_[@"name"];
        tenant.image = tenant_[@"image"];
        tenant.license = tenant_[@"license"];
        tenant.star = [tenant_[@"star"]integerValue];
        MCMarket* market = [[MCMarket alloc]init];
        market.name = tenant_[@"market_name"];
        tenant.market = market;
        NSMutableArray* vegetables = [[NSMutableArray alloc]init];
        MCVegetable* vegetable = [[MCVegetable alloc]init];
        vegetable.product_id = [dicResult[@"product_id"]integerValue];
        vegetable.shop_product_id =[tenant_[@"product_id"]integerValue];
        vegetable.price = [tenant_[@"price"]floatValue];
        vegetable.unit = dicResult[@"unit"];
        vegetable.originalPrice = [tenant_[@"original_price"]floatValue];
        vegetable.quantity = [tenant_[@"sales_quantity"]integerValue];
        [vegetables addObject:vegetable];
        tenant.vegetables = vegetables;
        [tenants addObject:tenant];
    }
    obj[@"tenants"] = tenants;
    
    NSArray* recipesArray = dicResult[@"recipes"];
    NSMutableArray* recipes = [[NSMutableArray alloc]init];
    for(int i=0;i<recipesArray.count;i++) {
        NSDictionary* recipe_ = recipesArray[i];
        MCRecipe* recipe = [[MCRecipe alloc]init];
        recipe.id = [recipe_[@"id"]integerValue];
        recipe.name = recipe_[@"name"];
        recipe.image = recipe_[@"image"];
        recipe.introduction = recipe_[@"introduction"];
        [recipes addObject:recipe];
    }
    obj[@"recipes"] = recipes;
    return obj;
}

-(NSMutableDictionary*)getShopVegetablesByShopId:(NSString*)id
{
    NSDictionary* params = @{
                             @"id":id
                             };
    NSMutableDictionary* data = [[NSMutableDictionary alloc]initWithDictionary:params];
    NSData* result = [[MCNetwork getInstance]httpGetSynUrl:@"http://star-faith.com:8083/maicai/api/ios/v1/public/tenant/list.do" Params:data Cache:YES];
    NSError *error;
    NSDictionary* responseData = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:&error];
    
    BOOL flag = [responseData[@"success"]boolValue];
    if(!flag) {
        @throw [NSException exceptionWithName:@"接口错误" reason:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] userInfo:nil];
    }
    
    NSDictionary* obj = responseData[@"data"];
    NSMutableArray* vegetables = [[NSMutableArray alloc]init];
    NSArray* dicResult = obj[@"products"];
    unsigned int i=0;
    for(i=0;i<dicResult.count;i++) {
        NSDictionary* vegetable = dicResult[i];
        MCVegetable* temp = [[MCVegetable alloc]init];
        temp.id = [vegetable[@"id"]integerValue];
        temp.name = (NSString*)vegetable[@"name"];
        temp.product_id = [vegetable[@"product_id"]integerValue];
        temp.shop_product_id = [vegetable[@"id"]integerValue];
        temp.price = [vegetable[@"price"]floatValue];
        temp.unit = (NSString*)vegetable[@"unit"];
        [vegetables addObject:temp];
    }
    NSMutableDictionary* finalResult = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                        @"shopName":[[NSString alloc]initWithFormat:@"%@%@",obj[@"market_name"],obj[@"tenant_name"]],
                                                                                        @"vegetables":vegetables
                                                                                        }];
    return finalResult;
}



-(NSMutableDictionary*)getRelationshipBetweenProductAndImage
{
    @synchronized (self){
        if(relationship == nil) {
            NSDictionary *resultData = @{
                                         @"21" :@"r_p_xiuzhengu" ,
                                         @"22" :@"r_p_qiezi" ,
                                         @"23" :@"r_p_xxxg" ,
                                         @"24" :@"r_p_chaotianjiao" ,
                                         @"25" :@"r_p_gswwc" ,
                                         @"26" :@"r_p_jinzhengu" ,
                                         @"27" :@"r_p_dasuanzi" ,
                                         @"28" :@"r_p_bdhg" ,
                                         @"29" :@"r_p_xiangqin" ,
                                         @"30" :@"r_p_xiangcong" ,
                                         @"31" :@"r_p_yangcong" ,
                                         @"32" :@"r_p_suantai" ,
                                         @"33" :@"r_p_donggua" ,
                                         @"34" :@"r_p_maoyutou"  ,
                                         @"35" :@"r_p_helandou" ,
                                         @"36" :@"r_p_xiaonangua" ,
                                         @"37" :@"r_p_xiaobaicai" ,
                                         @"38" :@"r_p_zajiao" ,
                                         @"39" :@"r_p_sijidou" ,
                                         @"40" :@"r_p_biandou" ,
                                         @"41" :@"r_p_caijiao" ,
                                         @"42" :@"r_p_jiaobai" ,
                                         @"43" :@"r_p_baocai" ,
                                         @"44" :@"r_p_zishu" ,
                                         @"45" :@"r_p_xinbaogu" ,
                                         @"46" :@"r_p_jimaocai" ,
                                         @"47" :@"r_p_xihongshi"  ,
                                         @"48" :@"r_p_jiucai" ,
                                         @"49" :@"r_p_xihulu" ,
                                         @"50" :@"r_p_tudou" ,
                                         @"51" :@"r_p_dabaicai" ,
                                         @"52" :@"r_p_shengjiang" ,
                                         @"53" :@"r_p_baihe" ,
                                         @"54" :@"r_p_ziganlan" ,
                                         @"55" :@"r_p_changdoujiao" ,
                                         @"56" :@"r_p_xilanhua" ,
                                         @"57" :@"r_p_jiuhuang" ,
                                         @"58" :@"r_p_dacong" ,
                                         @"59" :@"r_p_hongshu" ,
                                         @"60" :@"r_p_huluobu"  ,
                                         @"61" :@"r_p_bailuobu" ,
                                         @"62" :@"r_p_bpylb" ,
                                         @"63" :@"r_p_hpylb" ,
                                         @"64" :@"r_p_huacai" ,
                                         @"65" :@"r_p_yjhc" ,
                                         @"66" :@"r_p_maodou" ,
                                         @"67" :@"r_p_caiou" ,
                                         @"68" :@"r_p_huawangcai" ,
                                         @"69" :@"r_p_guangshanyao" ,
                                         @"70" :@"r_p_maoshanyao" ,
                                         @"71" :@"r_p_tgsy"
                                         };
            
            relationship = [[NSMutableDictionary alloc]initWithDictionary:resultData];
        }
        
    }
    return relationship;
}



@end
