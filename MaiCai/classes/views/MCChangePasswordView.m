//
//  MCChangePasswordView.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-21.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCChangePasswordView.h"
#import "MCPersonalInfoViewController.h"
#import "Toast+UIView.h"
#import "MCUserManager.h"
#import "Toast+UIView.h"
#import "DDLogConfig.h"

@interface MCChangePasswordView ()

@end

@implementation MCChangePasswordView

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
    // Do any additional setup after loading the view from its nib.
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtn:(id)sender {
    if (self.previousView.popupViewController != nil) {
        [self.previousView dismissPopupViewControllerAnimated:YES completion:^{
            DDLogVerbose(@"popup view dismissed");
        }];
    }

}

- (IBAction)okBtn:(id)sender {
    NSString* currentPassword = self.currentPasswordTF.text;
    NSString* newPassword = self.passwordTF.text;
    NSString* confirmNewPassword = self.confirmPasswordTF.text;
    
    if(currentPassword==nil || currentPassword.length == 0) {
        [self.view makeToast:@"请填写当前密码" duration:1 position:@"center"];
        return;
    }
    
    if(newPassword==nil || newPassword.length == 0) {
        [self.view makeToast:@"请填写新密码" duration:1 position:@"center"];
        return;
    }
    
    if(confirmNewPassword==nil || confirmNewPassword.length == 0) {
        [self.view makeToast:@"请填写确认密码" duration:1 position:@"center"];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[MCUserManager getInstance]changePassword:currentPassword NewPassword:newPassword]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.previousView.view makeToast:@"修改成功" duration:3 position:@"center"];
                if (self.previousView.popupViewController != nil) {
                    [self.previousView dismissPopupViewControllerAnimated:YES completion:^{
                        DDLogVerbose(@"popup view dismissed");
                    }];
                }
            });
        }else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.previousView.view makeToast:@"修改失败" duration:3 position:@"center"];
            });
        }
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
@end
