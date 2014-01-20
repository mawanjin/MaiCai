//
//  MCBaseViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-1.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Toast+UIView.h"

extern NSString* const MC_ERROR_MSG_0001;
extern NSString* const MC_ERROR_MSG_0002;
extern NSString* const MC_ERROR_MSG_0003;
extern NSString* const MC_ERROR_MSG_0004;

@interface MCBaseViewController : UIViewController
-(void)showMsgHint:(NSString*)msg;
@end
