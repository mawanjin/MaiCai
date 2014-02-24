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
#import "MCMineAddressViewController.h"
#import "MCAddressHelperViewController.h"


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
    
    if ([[MCContextManager getInstance]isBlankString:receiver]) {
        [self showMsgHint:@"请填写收货人姓名"];
        return;
    }
    
    if (![[MCContextManager getInstance]isMobileNumber:mobile]) {
        [self showMsgHint:@"请填写正确的收货人联系方式"];
        return;
    }
    
    if ([[MCContextManager getInstance]isBlankString:address]) {
        [self showMsgHint:@"请填写收货人地址"];
        return;
    }
    
    MCAddress* mcaddress = [[MCAddress alloc]init];
    mcaddress.shipper = receiver;
    mcaddress.mobile = mobile;
    mcaddress.address = address;
    MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.obj == nil) {
            if ([[MCUserManager getInstance]addUserAddress:mcaddress UserId:user.userId]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    [self backBtnAction];
                });
            }else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    //[self showMsgHint:MC_ERROR_MSG_0001];
                });
            }
            
        }else{
            mcaddress.id = self.obj.id;
            if ([[MCUserManager getInstance]updateUserAddress:mcaddress UserId:user.userId]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    [self backBtnAction];
                });
            }else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    //[self showMsgHint:MC_ERROR_MSG_0001];
                });
            }
        }
    });
}

- (IBAction)addressHelperAction:(id)sender {
    MCAddressHelperViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCAddressHelperViewController"];
    [vc setSelectionComplete:^(NSString *address) {
        self.address.text = address;
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc  animated:YES];

}

- (IBAction)tappedAction:(id)sender {
      [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end
