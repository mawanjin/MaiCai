//
//  MCVegetableManager.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-4.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCRecipe;
@class MCHealth;

@interface MCVegetableManager : NSObject
+(MCVegetableManager*)getInstance;
-(NSMutableDictionary*)getMarketIndexInfo;
-(NSMutableArray*)getMarketProducts;
-(NSMutableDictionary*)getVegetableDetailByProductId:(int)id Longitude:(NSString*)longitude Latitude:(NSString*)latitude;
-(NSMutableDictionary*)getShopVegetablesByShopId:(NSString*)id;
-(NSMutableArray*)getHotWordsByQuantity:(int)quantity;
-(NSMutableArray*)getSearchResultByKeywords:(NSString*)words Quantity:(int)quantity;
-(NSMutableArray*)getSuggestResultByKeywords:(NSString*)words Quantity:(int)quantity;
-(NSMutableArray*)getRecipesByPage:(int)page Pagesize:(int)pagesize;
-(NSMutableArray*)getHealthListByPage:(int)page Pagesize:(int)pagesize;
-(NSMutableArray*)getCollectionListByPage:(int)page Pagesize:(int)pagesize Recipe:(BOOL)flag UserId:(int)userId;
-(NSMutableArray*)getProductCategories;
//这是一键买菜接口
-(MCRecipe*)getRecipeById:(int)id;
//获取菜谱详情接口
-(MCRecipe*)getRecipeDetailById:(int)id;
//获取养身详情
-(MCHealth*)getHealthDetailById:(int)id;
//获取标签详情
-(NSDictionary*)getLabelDetailById:(int)id;
@end
