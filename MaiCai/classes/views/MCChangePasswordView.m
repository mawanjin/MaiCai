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
#import "NSString+Regex.h"


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
            MCLog(@"popup view dismissed");
        }];
    }

}

- (IBAction)okBtn:(id)sender {
    NSString* currentPassword = self.currentPasswordTF.text;
    NSString* newPassword = self.passwordTF.text;
    NSString* confirmNewPassword = self.confirmPasswordTF.text;
    
    
    if (![currentPassword isPassword]) {
        [self.view makeToast:@"密码6~10位" duration:1 position:@"center"];
        return;
    }
    
    if (![newPassword isPassword]) {
        [self.view makeToast:@"密码6~10位" duration:1 position:@"center"];
        return;
    }
    
    if(![confirmNewPassword isEqual:newPassword]) {
        [self.view makeToast:@"两次密码不一致" duration:1 position:@"center"];
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[MCUserManager getInstance]changePassword:currentPassword NewPassword:newPassword]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.previousView.view makeToast:@"修改成功" duration:3 position:@"center"];
                if (self.previousView.popupViewController != nil) {
                    [self.previousView dismissPopupViewControllerAnimated:YES completion:^{
                        MCLog(@"popup view dismissed");
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
