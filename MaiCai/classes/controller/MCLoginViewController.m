//
//  MCLoginViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-6.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCLoginViewController.h"
#import "MCAgreementViewController.h"
#import "MCUserManager.h"
#import "MCUser.h"
#import "Toast+UIView.h"
#import "NSString+Regex.h"
#import "MCRegisterViewController.h"


@implementation MCLoginViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- others
- (IBAction)loginBtnAction:(UIButton *)sender {
    NSString* userId = self.usernameTextField.text;
    NSString* password = self.passwordTextField.text;
    
    if (![userId isMobileNumber]) {
        [self showMsgHint:@"请输入正确的手机号码"];
        return;
    }
    
    if (![password isPassword]) {
        [self showMsgHint:@"请输入正确的密码"];
        return;
    }
    
    MCUser* user = [[MCUser alloc]init];
    user.userId = userId;
    user.password = password;
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[MCUserManager getInstance]login:user]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
                [self backBtnAction];
                if (self.loginComplete) {
                    double delayInSeconds = 1.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        self.loginComplete();
                        self.loginComplete = nil;
                        
                    });
                }
            });
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"登入失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
            });
        }
    });
}

- (IBAction)viewClickAction:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)registerAction:(UIButton *)sender {
    MCAgreementViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCAgreementViewController"];
    [vc setAgreeComplete:^{
        MCRegisterViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCRegisterViewController"];
        vc.hidesBottomBarWhenPushed = YES;
            [vc setShowMsg:^(NSString * msg) {
                [self showMsgHint:msg];
            }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    vc.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
@end
