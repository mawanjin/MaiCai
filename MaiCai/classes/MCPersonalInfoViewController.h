//
//  MCPersonalInfoViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-11-20.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"

@interface MCPersonalInfoViewController :MCBaseNavViewController

@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
- (IBAction)changePasswordAction:(id)sender;
- (IBAction)changeNicknameAction:(id)sender;

@end
