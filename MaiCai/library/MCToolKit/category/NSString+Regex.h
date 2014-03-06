//
//  NSString+Regex.h
//  MaiCai
//
//  Created by Peng Jack on 14-2-24.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)
- (BOOL)isMobileNumber;
- (BOOL)isBlankString;
- (BOOL)isPassword;
- (BOOL)isEmail;
@end
