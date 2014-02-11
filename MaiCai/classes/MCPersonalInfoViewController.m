//
//  MCPersonalInfoViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-20.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCPersonalInfoViewController.h"
#import "MCUserManager.h"
#import "MCUser.h"
#import "MCContextManager.h"
#import "UIViewController+CWPopup.h"
#import "MCChangePasswordView.h"
#import "MCChangeNicknameView.h"

@interface MCPersonalInfoViewController ()

@end

@implementation MCPersonalInfoViewController

#pragma mark- base
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
            user = [[MCUserManager getInstance]getUserInfo:user.userId];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.nickNameLabel.text = [[NSString alloc]initWithFormat:@"我的昵称：%@",user.name];
                self.userIdLabel.text = [[NSString alloc]initWithFormat:@"我的账号：%@",user.userId];
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
            });
        }

    });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- others
- (IBAction)changePasswordAction:(id)sender {
    MCChangePasswordView *popup = [[MCChangePasswordView alloc] initWithNibName:@"MCChangePasswordView" bundle:nil];
     popup.previousView = self;
    [self presentPopupViewController:popup animated:YES completion:nil];
}

- (IBAction)changeNicknameAction:(id)sender {
    MCChangeNicknameView *popup = [[MCChangeNicknameView alloc] initWithNibName:@"MCChangeNicknameView" bundle:nil];
    popup.previousView = self;
    [self presentPopupViewController:popup animated:YES completion:nil];
}
@end
