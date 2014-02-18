//
//  MCLoginViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-6.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCLoginViewController.h"
#import "MCUserManager.h"
#import "MCUser.h"
#import "Toast+UIView.h"

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
    
    MCUser* user = [[MCUser alloc]init];
    user.userId = userId;
    user.password = password;
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            [[MCUserManager getInstance]login:user];
            dispatch_sync(dispatch_get_main_queue(), ^{
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
        }
        @catch (NSException *exception) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"登入失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
            });
        }@finally {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
            });
        }
    });
}

- (IBAction)viewClickAction:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)registerAction:(UIButton *)sender {
    MCRegisterViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCRegisterViewController"];
    [vc setShowMsg:^(NSString * msg) {
        [self showMsgHint:msg];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
@end
