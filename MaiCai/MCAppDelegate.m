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


@implementation MCAppDelegate

#pragma mark - base
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //两秒以后加载程序，能让用户更加仔细的看清楚，启动画面
    //[NSThread sleepForTimeInterval:1.0];
    
    //状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //免登入操作
    MCUserManager* userManager = [MCUserManager getInstance];
    MCUser* user = [userManager getLoginStatus];
    if(user!=nil) {
        [[MCContextManager getInstance] addKey:MC_USER Data:user];
        [[MCContextManager getInstance] setLogged:YES];
    }else {
        NSString *udid = [[UIDevice currentDevice] uniqueAdvertisingIdentifier];
        [[MCContextManager getInstance] addKey:MC_MAC_ID Data:udid];
        [[MCContextManager getInstance] setLogged:NO];
    }
    
    //错误处理操作
    // Default exception handling code
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings boolForKey:@"ExceptionOccurredOnLastRun"])
    {
        // Reset exception occurred flag
        [settings setBool:NO forKey:@"ExceptionOccurredOnLastRunKey"];
        [settings synchronize];
        // Notify the user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"抱歉"
                                                        message:@"应用存在错误，异常退出了！" delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"上传错误报告"];
        [alert show];
    }else
    {
        NSSetUncaughtExceptionHandler(&exceptionHandler);
        // Redirect stderr output stream to file
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                             NSUserDomainMask, YES);
//        NSString *documentsPath = [paths objectAtIndex:0];
//        NSString *stderrPath = [documentsPath stringByAppendingPathComponent:@"stderr.log"];
//        freopen([stderrPath cStringUsingEncoding:NSASCIIStringEncoding], "w", stderr);
    }
    
    //根据不同的屏幕尺寸加载不同的程序
    [self initializeStoryBoardBasedOnScreenSize];
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

-(void)initializeStoryBoardBasedOnScreenSize {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
            UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"Main_iphone4" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = initialViewController;
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        }
        
        if (iOSDeviceScreenSize.height == 568)
        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen (diagonally measured)
            
            // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
            UIStoryboard *iPhone4Storyboard = [UIStoryboard storyboardWithName:@"Main_iphone5" bundle:nil];
            
            // Instantiate the initial view controller object from the storyboard
            UIViewController *initialViewController = [iPhone4Storyboard instantiateInitialViewController];
            
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            // Set the initial view controller to be the root view controller of the window object
            self.window.rootViewController  = initialViewController;
            
            // Set the window object to be the key window and show it
            [self.window makeKeyAndVisible];
        }
        
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        
    {   // The iOS device = iPad
        
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
    }
}

#pragma mark- alipay
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
                if ([[MCTradeManager getInstance]cancelPaymentByPaymentNo:self.pay_no]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.pay_no = nil;
                        if(self.alipayEndAction) {
                            self.alipayEndAction();
                            self.alipayEndAction = nil;
                        }
                    });
                }else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if(self.alipayErrorAction) {
                            self.alipayErrorAction();
                            self.alipayErrorAction = nil;
                        }
                    });
                }
            });
        }
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([[MCTradeManager getInstance]cancelPaymentByPaymentNo:self.pay_no]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.pay_no = nil;
                    if(self.alipayEndAction) {
                        self.alipayEndAction();
                        self.alipayEndAction = nil;
                    }
                });
            }else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(self.alipayErrorAction) {
                        self.alipayErrorAction();
                        self.alipayErrorAction = nil;
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

#pragma mark- exception handler
void exceptionHandler(NSException *exception)
{
    //Set flag
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setBool:YES forKey:@"ExceptionOccurredOnLastRun"];
    [settings synchronize];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //todo: Email a report here
    }
}

@end
