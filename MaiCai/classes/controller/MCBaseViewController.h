//
//  MCBaseViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-1.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast+UIView.h"



@interface MCBaseViewController : UIViewController
-(void)showMsgHint:(NSString*)msg;
-(void)showProgressHUD;
-(void)hideProgressHUD;
@end
