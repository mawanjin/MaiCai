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
#import "MCOrderDetailViewController.h"
#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

@implementation MCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //两秒以后加载程序，能让用户更加仔细的看清楚，启动画面
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
        [[MCContextManager getInstance] addKey:MC_MAC_ID Data:udid];
        [[MCContextManager getInstance] setLogged:NO];
    }
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
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
                    [[MCTradeManager getInstance]cancelPaymentByPaymentNo:self.pay_no];
                }
                @catch (NSException *exception) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(self.alipayErrorAction) {
                            self.alipayErrorAction();
                            self.alipayErrorAction = nil;
                        }
                    });
                }
                @finally {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.pay_no = nil;
                        if(self.alipayEndAction) {
                            self.alipayEndAction();
                            self.alipayEndAction = nil;
                        }
                    });
                }
            });

        }
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                [[MCTradeManager getInstance]cancelPaymentByPaymentNo:self.pay_no];
            }
            @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(self.alipayErrorAction) {
                            self.alipayErrorAction();
                            self.alipayErrorAction = nil;
                        }
                    });

                });
            }
            @finally {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.pay_no = nil;
                    if(self.alipayEndAction) {
                        self.alipayEndAction();
                        self.alipayEndAction = nil;
                    }
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
