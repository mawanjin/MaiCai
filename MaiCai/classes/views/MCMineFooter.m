//
//  MCMineFooter.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-18.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMineFooter.h"
#import "MCContextManager.h"
#import "MCLoginViewController.h"
#import "MCUserManager.h"

@implementation MCMineFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(id)initInstance
{
    UIView* view = [[[NSBundle mainBundle]loadNibNamed:@"MCMineFooter" owner:self options:nil]lastObject];
    return view;
}

- (IBAction)clickAction:(UIButton *)sender {
    BOOL isLoged = [[MCContextManager getInstance]isLogged];
    
    if(isLoged) {
        UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"确定需要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:nil];
        MCLoginViewController* vc = [sb instantiateViewControllerWithIdentifier:@"MCLoginViewController"];
        [self.parentView.navigationController pushViewController:vc animated:YES];
    }
   
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[MCUserManager getInstance]clearLoginStatus];
        [[MCContextManager getInstance]setLogged:NO];
        [self.parentView viewWillAppear:YES];
        
    }else{
        return;
    }
}

@end
