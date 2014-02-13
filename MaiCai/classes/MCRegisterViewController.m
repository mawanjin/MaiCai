//
//  MCRegisterViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-19.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCRegisterViewController.h"
#import "MCUserManager.h"
#import "MCContextManager.h"
#import "MCUser.h"
#import "MCLoginViewController.h"
#import "Toast+UIView.h"


@implementation MCRegisterViewController

- (IBAction)registerBtn:(UIButton *)sender {
    NSString* username = self.username.text;
    NSString* nickname = self.nickname.text;
    NSString* password = self.password.text;
    NSString* passwordAgain = self.passwordAgain.text;
    
    if(![password isEqual:passwordAgain]) {
        [self showMsgHint:@"两次密码不一致"];
        return;
    }
    
    MCUser* user = [[MCUser alloc]init];
    user.userId = username;
    user.name = nickname;
    user.password = password;
    [self showProgressHUD];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            [[MCUserManager getInstance]registerUser:user MacId:(NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID]];
            //[[MCContextManager getInstance] addKey:MC_USER Data:user];
            //[[MCContextManager getInstance]setLogged:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate showHintMessage:@"注册成功,请登入"];
                [self backBtnAction];
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:@"注册失败"];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
            });
        }

    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
@end
