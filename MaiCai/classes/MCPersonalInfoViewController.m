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
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
#import "UIViewController+CWPopup.h"
#import "MCChangePasswordView.h"
#import "MCChangeNicknameView.h"

@interface MCPersonalInfoViewController ()

@end

@implementation MCPersonalInfoViewController

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
    
    [MBProgressHUD allHUDsForView:self.view];
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
                [self.view makeToast:@"无法连接网络资源" duration:2 position:@"center"];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD  hideHUDForView:self.view animated:YES];
            });
        }

    });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
