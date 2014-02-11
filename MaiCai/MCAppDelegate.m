//
//  MCAppDelegate.m
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCAppDelegate.h"
#import "MCUserManager.h"
#import "MCContextManager.h"
#import "MCUser.h"
#import "UIDevice+IdentifierAddition.h"

#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "MCTradeManager.h"
#import "MCBaseNavViewController.h"
#import "MCOrderConfirmViewController.h"
#import "MCOrderDetailViewController.h"

@implementation MCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:2.0];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //MCDBManger* dbManger = [MCDBManger getInstance];
    //[dbManger createTable];
    
    MCUserManager* userManager = [MCUserManager getInstance];
    //MCUser* user = [userManager getDefaultUser];
    MCUser* user = [userManager getLoginStatus];
    if(user!=nil) {
        [[MCContextManager getInstance] addKey:MC_USER Data:user];
        [[MCContextManager getInstance] setLogged:YES];
    }else {
        NSString *udid = [[UIDevice currentDevice] uniqueAdvertisingIdentifier];
        NSLog(@"udid---%@-----",udid);
        [[MCContextManager getInstance] addKey:MC_MAC_ID Data:udid];
        [[MCContextManager getInstance] setLogged:NO];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//独立客户端回调函数
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parse:url application:application];
	return YES;
}

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
//            NSString* key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"];//签约帐户后获取到的支付宝公钥
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            
//			if ([verifier verifyString:result.resultString withSign:result.signString])
//           {
//               
//           }
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @try {
                    if([self.controller isKindOfClass: [MCOrderConfirmViewController class] ]) {
                        MCOrderConfirmViewController* controller = (MCOrderConfirmViewController*)self.controller;
                        [[MCTradeManager getInstance]cancelPaymentByPaymentNo:controller.pay_no];
                    }else if([self.controller isKindOfClass:[MCOrderDetailViewController class]]) {
                        MCOrderDetailViewController* controller = (MCOrderDetailViewController*)self.controller;
                         [[MCTradeManager getInstance]cancelPaymentByPaymentNo:controller.pay_no];
                    }
                    
                }
                @catch (NSException *exception) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.controller showMsgHint:MC_ERROR_MSG_0001];
                        [self.controller backBtnAction];
                    });
                }
                @finally {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.controller.previousView showMsgHint:@"交易失败"];
                        [self.controller backBtnAction];
                    });
                }
            });

        }
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                if([self.controller isKindOfClass: [MCOrderConfirmViewController class] ]) {
                    MCOrderConfirmViewController* controller = (MCOrderConfirmViewController*)self.controller;
                    [[MCTradeManager getInstance]cancelPaymentByPaymentNo:controller.pay_no];
                }else if([self.controller isKindOfClass:[MCOrderDetailViewController class]]) {
                    MCOrderDetailViewController* controller = (MCOrderDetailViewController*)self.controller;
                    [[MCTradeManager getInstance]cancelPaymentByPaymentNo:controller.pay_no];
                }
            }
            @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.controller showMsgHint:MC_ERROR_MSG_0001];
                        [self.controller backBtnAction];
                    });

                });
            }
            @finally {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.controller.previousView showMsgHint:@"交易失败"];
                    [self.controller backBtnAction];
                });
            }
        });

    }
    
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

@end
