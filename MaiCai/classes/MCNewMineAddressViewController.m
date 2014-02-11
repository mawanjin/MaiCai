//
//  MCNewMineAdressViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-11.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCNewMineAddressViewController.h"
#import "MCUserManager.h"
#import "MCAddress.h"
#import "MCUser.h"
#import "MCContextManager.h"
#import "MCAddressHelperView.h"
#import "MCMineAddressViewController.h"


@implementation MCNewMineAddressViewController

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
    if(self.obj !=nil) {
        self.receiver.text = self.obj.shipper;
        self.mobile.text = self.obj.mobile;
        self.address.text = self.obj.address;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- others
- (IBAction)okBtnAction:(id)sender {
    NSString* receiver = [self.receiver.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* mobile = [self.mobile.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* address = [self.address.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(receiver==Nil || receiver.length == 0) {
        [self showMsgHint:MC_ERROR_MSG_0002];
        return;
    }
    
    if(mobile==Nil || mobile.length == 0) {
        [self showMsgHint:MC_ERROR_MSG_0003];
        return;
    }
    
    if(address==Nil || address.length == 0) {
        [self showMsgHint:MC_ERROR_MSG_0004];
        return;
    }
    
    MCAddress* mcaddress = [[MCAddress alloc]init];
    mcaddress.shipper = receiver;
    mcaddress.mobile = mobile;
    mcaddress.address = address;
    MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            if (self.obj == nil) {
                [[MCUserManager getInstance]addUserAddress:mcaddress UserId:user.userId];
            }else{
                mcaddress.id = self.obj.id;
                [[MCUserManager getInstance]updateUserAddress:mcaddress UserId:user.userId];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [self dismissViewControllerAnimated:NO completion:^{
                }];
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:MC_ERROR_MSG_0001];
            });
        }@finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgressHUD];
            });
        }
    });
}

- (IBAction)addressHelperAction:(id)sender {
    MCAddressHelperView *popup = [[MCAddressHelperView alloc] initWithNibName:@"MCAddressHelperView" bundle:nil];
    popup.previousView = self;
    [self presentPopupViewController:popup animated:YES completion:nil];

}

- (IBAction)tappedAction:(id)sender {
      [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
