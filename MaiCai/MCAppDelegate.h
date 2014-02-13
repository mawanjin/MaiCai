//
//  MCAppDelegate.h
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayViewController;
@class MCBaseNavViewController;

@interface MCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property BOOL isReachable;
@property (strong, nonatomic) PayViewController *payViewController;
@property (strong,atomic) NSString* pay_no;
@property (strong,nonatomic) void(^alipayEndAction)();
@property (strong,nonatomic) void(^alipayErrorAction)();
@end
