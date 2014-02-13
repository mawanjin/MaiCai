//
//  MCRegisterViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-19.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCBaseNavViewController.h"

@interface MCRegisterViewController : MCBaseNavViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgain;
@property (nonatomic,strong) void(^showMsg)(NSString* msg);

- (IBAction)registerBtn:(UIButton *)sender;
@end
