//
//  UILabel+MCAutoResize.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-31.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MCAutoResize)
-(void)autoResizeByText:(NSString*)text PositionX:(float)x PositionY:(float)y;
+(CGFloat)calculateHeightByText:(NSString*)text;
@end
