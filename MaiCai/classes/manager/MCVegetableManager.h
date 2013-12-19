//
//  MCVegetableManager.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-4.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCVegetableManager : NSObject
+(MCVegetableManager*)getInstance;
-(NSMutableDictionary*)getMarketIndexInfo;
-(NSMutableArray*)getMarketProducts;
-(NSMutableDictionary*)getRelationshipBetweenProductAndImage;
-(NSMutableArray*)getShopVegetablesByProductId:(int)id Longitude:(NSString*)longitude Latitude:(NSString*)latitude;
-(NSMutableDictionary*)getShopVegetablesByShopId:(NSString*)id;
@end
