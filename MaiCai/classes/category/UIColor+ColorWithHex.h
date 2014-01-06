//
//  UIColor+ColorWithHex.h
//  MaiCai
//
//  Created by Peng Jack on 14-1-6.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorWithHex)
+(UIColor*)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha;
+(UIColor*)colorWithHexString:(NSString *)hexString andAlpha:(float)alpha;
@end
