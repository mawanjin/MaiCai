//
//  MCChangeNicknameViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-21.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCChangeNicknameView.h"
#import "MCPersonalInfoViewController.h"
#import "Toast+UIView.h"
#import "MCUserManager.h"
#import "MBProgressHUD.h"

@implementation MCChangeNicknameView

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

- (IBAction)okBtnAction:(id)sender {
    NSString* nickname = self.textField.text;
        
    if(nickname==nil || nickname.length == 0) {
        [self.view makeToast:@"请填写需要修改的昵称！" duration:1 position:@"center"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[MCUserManager getInstance]changeNickName:nickname]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.previousView.view makeToast:@"修改成功" duration:1 position:@"center"];
                [self.previousView.nickNameLabel setText:[[NSString alloc]initWithFormat:@"我的昵称：%@",nickname]];
                if (self.previousView.popupViewController != nil) {
                    [self.previousView dismissPopupViewControllerAnimated:YES completion:^{
                        MCLog(@"popup view dismissed");
                    }];
                }
            });
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.previousView.view makeToast:@"修改失败" duration:1 position:@"center"];
            });
        }
    });
}

- (IBAction)cancelBtnAction:(id)sender {
    if (self.previousView.popupViewController != nil) {
        [self.previousView dismissPopupViewControllerAnimated:YES completion:^{
            MCLog(@"popup view dismissed");
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
@end
