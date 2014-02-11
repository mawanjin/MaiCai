//
//  MCFeedbackViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCFeedbackViewController.h"
#import "MCUserManager.h"
#import "GCPlaceholderTextView.h"

@interface MCFeedbackViewController ()

@end

@implementation MCFeedbackViewController
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
    self.content.placeholderColor = [UIColor lightGrayColor];
    self.content.placeholder = NSLocalizedString(@"请留下你的宝贵意见。",);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- others
- (IBAction)submitBtnAction:(UIButton *)sender {
    NSString* content = [self.content.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString* tel = [self.tel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([content isEqual:@""]){
        [self showMsgHint:@"请提供您的宝贵意见"];
        return;
    }
    
    if([tel isEqual:@""]) {
        [self showMsgHint:@"请提供你的联系方式"];
        return;
    }
    
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            [[MCUserManager getInstance]feedbackByTel:tel Content:content];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMsgHint:@"提交成功"];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
