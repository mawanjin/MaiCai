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
#import "MCRegisterViewController.h"

@implementation MCLoginViewController

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

- (IBAction)loginBtnAction:(UIButton *)sender {
    NSString* userId = self.usernameTextField.text;
    NSString* password = self.passwordTextField.text;
    
    MCUser* user = [[MCUser alloc]init];
    user.userId = userId;
    user.password = password;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            [[MCUserManager getInstance]login:user];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self backBtnAction];
            });
        }
        @catch (NSException *exception) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"登入失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
            });
        }@finally {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        }
    });
}

- (IBAction)viewClickAction:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)registerAction:(UIButton *)sender {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    MCRegisterViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCRegisterViewController"];
    vc.previousView = self;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc]
                       animated:NO completion:^{
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


@end
