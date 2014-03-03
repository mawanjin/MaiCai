//
//  MCLoginViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-6.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"

@interface MCLoginViewController : MCBaseNavViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong,nonatomic) void(^loginComplete)();
@property (strong,nonatomic) void(^registerComplete)();

- (IBAction)loginBtnAction:(UIButton *)sender;
- (IBAction)viewClickAction:(id)sender;
- (IBAction)registerAction:(UIButton *)sender;

@end
