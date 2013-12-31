//
//  MCVegetableManager.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-4.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCRecipe;

@interface MCVegetableManager : NSObject
+(MCVegetableManager*)getInstance;
-(NSMutableDictionary*)getMarketIndexInfo;
-(NSMutableArray*)getMarketProducts;
-(NSMutableDictionary*)getRelationshipBetweenProductAndImage;
-(NSMutableArray*)getShopVegetablesByProductId:(int)id Longitude:(NSString*)longitude Latitude:(NSString*)latitude;
-(NSMutableDictionary*)getShopVegetablesByShopId:(NSString*)id;
-(NSMutableArray*)getHotWordsByQuantity:(int)quantity;
-(NSMutableArray*)getSearchResultByKeywords:(NSString*)words Quantity:(int)quantity;
-(NSMutableArray*)getSuggestResultByKeywords:(NSString*)words Quantity:(int)quantity;
-(NSMutableArray*)getRecipesByPage:(int)page Pagesize:(int)pagesize;
-(NSMutableArray*)getHealthListByPage:(int)page Pagesize:(int)pagesize;
//这是一键买菜接口
-(MCRecipe*)getRecipeById:(int)id;

//获取菜谱详情接口
-(MCRecipe*)getRecipeDetailById:(int)id;
@end
